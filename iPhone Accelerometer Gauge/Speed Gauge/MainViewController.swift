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
    
    let updatesIntervalOn = 0.01
    let updatesIntervalOff = 0.1
    let gravity = 9.81

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface() // Include labels and buttons.
    }

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var speedTextLabel: UILabel!
    @IBOutlet weak var speedValueLabel: UILabel!
    @IBOutlet weak var accelerationXTextLabel: UILabel!
    @IBOutlet weak var accelerationYTextLabel: UILabel!
    @IBOutlet weak var accelerationZTextLabel: UILabel!
    @IBOutlet weak var accelerationXValueLabel: UILabel!
    @IBOutlet weak var accelerationYValueLabel: UILabel!
    @IBOutlet weak var accelerationZValueLabel: UILabel!
    @IBOutlet weak var velocityXTextLabel: UILabel!
    @IBOutlet weak var velocityYTextLabel: UILabel!
    @IBOutlet weak var velocityZTextLabel: UILabel!
    @IBOutlet weak var velocityXValueLabel: UILabel!
    @IBOutlet weak var velocityYValueLabel: UILabel!
    @IBOutlet weak var velocityZValueLabel: UILabel!
    
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
    
    func initializeInterface(){
        playButton.isHidden = false
        pauseButton.isHidden = true
        
        speedTextLabel.text = "Speed"
        accelerationXTextLabel.text = "Acceleration X Axis:"
        accelerationYTextLabel.text = "Acceleration Y Axis:"
        accelerationZTextLabel.text = "Acceleration Z Axis:"
        
        speedValueLabel.text = nil
        accelerationXValueLabel.text = nil
        accelerationYValueLabel.text = nil
        accelerationZValueLabel.text = nil
        
        velocityXTextLabel.text = "Velocity X Axis:"
        velocityYTextLabel.text = "Velocity Y Axis:"
        velocityZTextLabel.text = "Velocity Z Axis:"
        
        velocityXValueLabel.text = nil
        velocityYValueLabel.text = nil
        velocityZValueLabel.text = nil
    }
    
    func updateLabels(){
        self.accelerationXValueLabel.text = String(format: "%.4f", arguments: [accelerometerXData.last!])
        self.accelerationYValueLabel.text = String(format: "%.4f", arguments: [accelerometerYData.last!])
        self.accelerationZValueLabel.text = String(format: "%.4f", arguments: [accelerometerZData.last!])
        
        self.velocityXValueLabel.text = String(format: "%.4f", arguments: [velocityXData.last!])
        self.velocityYValueLabel.text = String(format: "%.4f", arguments: [velocityYData.last!])
        self.velocityZValueLabel.text = String(format: "%.4f", arguments: [velocityZData.last!])
        
        self.speedValueLabel.text = String(format: "%.4f", arguments: [speedData.last!])
    }
    
    func playSound(){
        AudioServicesPlaySystemSound(1052) // SIMToolkitGeneralBeep.caf
    }
    
}
