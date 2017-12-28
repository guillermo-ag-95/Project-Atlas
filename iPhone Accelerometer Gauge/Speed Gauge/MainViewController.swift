//
//  MainViewController.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 16/11/17.
//  Copyright © 2017 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class MainViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    
    var accelerometerXData: [Double] = []
    var accelerometerYData: [Double] = []
    var accelerometerZData: [Double] = []
    
    var velocityXData: [Double] = []
    var velocityYData: [Double] = []
    var velocityZData: [Double] = []
    
    var speedData: [Double] = []
    
    let updatesIntervalOn = 0.01 // 100 Hz (1/100 s)
    let updatesIntervalOff = 0.1 // 10 Hz (1/10 s)
    let gravity = 9.81

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Addition of the UI Elements.
        view.addSubview(playButton)
        view.addSubview(pauseButton)
        
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(textStackView)
        mainStackView.addArrangedSubview(valuesStackView)
        
        textStackView.addArrangedSubview(speedTextLabel)
        textStackView.addArrangedSubview(accelerationXTextLabel)
        textStackView.addArrangedSubview(accelerationYTextLabel)
        textStackView.addArrangedSubview(accelerationZTextLabel)
        textStackView.addArrangedSubview(velocityXTextLabel)
        textStackView.addArrangedSubview(velocityYTextLabel)
        textStackView.addArrangedSubview(velocityZTextLabel)
        
        valuesStackView.addArrangedSubview(speedValueLabel)
        valuesStackView.addArrangedSubview(accelerationXValueLabel)
        valuesStackView.addArrangedSubview(accelerationYValueLabel)
        valuesStackView.addArrangedSubview(accelerationZValueLabel)
        valuesStackView.addArrangedSubview(velocityXValueLabel)
        valuesStackView.addArrangedSubview(velocityYValueLabel)
        valuesStackView.addArrangedSubview(velocityZValueLabel)

        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        // Addition of custom constraints.
        playPauseButtonContraints(button: playButton)
        playPauseButtonContraints(button: pauseButton)
        
        mainStackConstraints()
        textStackConstraints()
        valuesStackConstraints()

        super.updateViewConstraints()
    }
    
    @IBAction func playPauseButtonPressed(_ sender: UIButton) {
        // Updates which button is shown.
        playButton.isHidden = !playButton.isHidden
        pauseButton.isHidden = !pauseButton.isHidden
        
        // Updates the interval to avoid 100Hz when the app is paused.
        self.motionManager.deviceMotionUpdateInterval = playButton.isHidden ? self.updatesIntervalOn : self.updatesIntervalOff

        playButton.isHidden ? startRecordData() : stopRecordData()
    }
    
    func startRecordData(){
        guard motionManager.isDeviceMotionAvailable else { return }
        
        initializeStoredData()
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
            if let data = data {
                self.updateStoredData(data)
                self.updateLabels()
            }
        }
    }
    
    func stopRecordData(){
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.stopDeviceMotionUpdates()
    }
    
    func initializeStoredData(){
        accelerometerXData.removeAll()
        accelerometerXData.append(0)
        accelerometerYData.removeAll()
        accelerometerYData.append(0)
        accelerometerZData.removeAll()
        accelerometerZData.append(0)
        
        velocityXData.removeAll()
        velocityXData.append(0)
        velocityYData.removeAll()
        velocityYData.append(0)
        velocityZData.removeAll()
        velocityZData.append(0)
        
        speedData.removeAll()
        speedData.append(0)
    }
    
    func updateStoredData(_ data: CMDeviceMotion){
        // https://www.nxp.com/docs/en/application-note/AN3397.pdf
        // https://www.wired.com/story/iphone-accelerometer-physics/
        
        var newXAcceleration = data.userAcceleration.x * self.gravity
        var newYAcceleration = data.userAcceleration.y * self.gravity
        var newZAcceleration = data.userAcceleration.z * self.gravity
        
        // Filter
        if abs(newXAcceleration) < 0.05 { newXAcceleration = 0 }
        if abs(newYAcceleration) < 0.05 { newYAcceleration = 0 }
        if abs(newZAcceleration) < 0.05 { newZAcceleration = 0 }
        
        // Instant velocity calculation by Integration
        let newXVelocity = (accelerometerXData.last! * updatesIntervalOn) + (newXAcceleration - accelerometerXData.last!) * (updatesIntervalOn / 2)
        let newYVelocity = (accelerometerYData.last! * updatesIntervalOn) + (newYAcceleration - accelerometerYData.last!) * (updatesIntervalOn / 2)
        let newZVelocity = (accelerometerZData.last! * updatesIntervalOn) + (newZAcceleration - accelerometerZData.last!) * (updatesIntervalOn / 2)
        
        // Current velocity by cumulative velocities.
        let currentXVelocity = velocityXData.last! + newXVelocity
        let currentYVelocity = velocityYData.last! + newYVelocity
        let currentZVelocity = velocityZData.last! + newZVelocity

        let currentSpeed = sqrt(pow(currentXVelocity, 2) + pow(currentYVelocity, 2) + pow(currentZVelocity, 2))
        
        // Data storage
        accelerometerXData.append(newXAcceleration)
        accelerometerYData.append(newYAcceleration)
        accelerometerZData.append(newZAcceleration)
        
        velocityXData.append(currentXVelocity)
        velocityYData.append(currentYVelocity)
        velocityZData.append(currentZVelocity)
        
        speedData.append(currentSpeed)
        
    }
    
    // INTERFACE UPDATES
    
    func updateLabels(){
        self.accelerationXValueLabel.text = String(format: "%.4f", arguments: [accelerometerXData.last!])
        self.accelerationYValueLabel.text = String(format: "%.4f", arguments: [accelerometerYData.last!])
        self.accelerationZValueLabel.text = String(format: "%.4f", arguments: [accelerometerZData.last!])
        
        self.velocityXValueLabel.text = String(format: "%.4f", arguments: [velocityXData.last!])
        self.velocityYValueLabel.text = String(format: "%.4f", arguments: [velocityYData.last!])
        self.velocityZValueLabel.text = String(format: "%.4f", arguments: [velocityZData.last!])
        
        self.speedValueLabel.text = String(format: "%.4f", arguments: [speedData.last!])
    }
    
    // MARK: - INTERFACE DECLARATION
    
    lazy var playButton: UIButton! = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(MainViewController.playPauseButtonPressed(_:)), for: .touchDown)
        view.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        view.backgroundColor = UIColor.white
        view.isHidden = false
       return view
    }()
    
    lazy var pauseButton: UIButton! = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(MainViewController.playPauseButtonPressed(_:)), for: .touchDown)
        view.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    
    lazy var speedTextLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Speed"
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var speedValueLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = nil
        view.textAlignment = .center
        return view
    }()
    
    lazy var accelerationXTextLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Acceleration X Axis:"
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var accelerationYTextLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Acceleration Y Axis:"
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var accelerationZTextLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Acceleration Z Axis:"
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var accelerationXValueLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = nil
        view.textAlignment = .center
        return view
    }()
    
    lazy var accelerationYValueLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = nil
        view.textAlignment = .center
        return view
    }()
    
    lazy var accelerationZValueLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = nil
        view.textAlignment = .center
        return view
    }()
    
    lazy var velocityXTextLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Velocity X Axis:"
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var velocityYTextLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Velocity Y Axis:"
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var velocityZTextLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Velocity Z Axis:"
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var velocityXValueLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = nil
        view.textAlignment = .center
        return view
    }()
    
    lazy var velocityYValueLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = nil
        view.textAlignment = .center
        return view
    }()
    
    lazy var velocityZValueLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = nil
        view.textAlignment = .center
        return view
    }()
    
    lazy var mainStackView: UIStackView! = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 0.0
        return view
    }()
    
    lazy var textStackView: UIStackView! = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 0.0
        return view
    }()
    
    lazy var valuesStackView: UIStackView! = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 0.0
        return view
    }()
    
    // MARK: - INTERFACE CONSTRAINTS

    func playPauseButtonContraints(button: UIButton){
        NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 0.95, constant: 0.0).isActive = true
    }
    
    func mainStackConstraints(){
        NSLayoutConstraint(item: mainStackView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 16.0).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .bottom, relatedBy: .equal, toItem: playButton, attribute: .top, multiplier: 0.95, constant: 0.0).isActive = true
    }
    
    func textStackConstraints(){
        NSLayoutConstraint(item: textStackView, attribute: .leading, relatedBy: .equal, toItem: mainStackView, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: textStackView, attribute: .top, relatedBy: .equal, toItem: mainStackView, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: textStackView, attribute: .bottom, relatedBy: .equal, toItem: mainStackView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: textStackView, attribute: .width, relatedBy: .equal, toItem: mainStackView, attribute: .width, multiplier: 0.55, constant: 0.0).isActive = true
    }
    
    func valuesStackConstraints(){
        NSLayoutConstraint(item: valuesStackView, attribute: .trailing, relatedBy: .equal, toItem: mainStackView, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: valuesStackView, attribute: .top, relatedBy: .equal, toItem: mainStackView, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: valuesStackView, attribute: .bottom, relatedBy: .equal, toItem: mainStackView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: valuesStackView, attribute: .width, relatedBy: .equal, toItem: mainStackView, attribute: .width, multiplier: 0.45, constant: 0.0).isActive = true
    }
    
    // MARK: - ANCILLARY FUNCTIONS
    
    func playSound(){
        AudioServicesPlaySystemSound(1052) // SIMToolkitGeneralBeep.caf
    }
    
}
