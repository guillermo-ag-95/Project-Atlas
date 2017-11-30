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
    
    var velocityXData: [Double] = [0]
    var velocityYData: [Double] = [0]
    var velocityZData: [Double] = [0]
    
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
        accelerometerYData.removeAll()
        accelerometerZData.removeAll()
        
        velocityXData.removeAll()
        velocityXData.append(0)
        velocityYData.removeAll()
        velocityYData.append(0)
        velocityZData.removeAll()
        velocityZData.append(0)
    }
    
    func updateStoredData(_ data: CMDeviceMotion){
        
        accelerometerXData.append(data.userAcceleration.x * gravity)
        accelerometerYData.append(data.userAcceleration.y * gravity)
        accelerometerZData.append(data.userAcceleration.z * gravity)
        
        calculateVelocityByAccelerationDefinition()
    }
    
    func calculateVelocityByAccelerationDefinition(){
        // Vi = Vi-1 + ai*t
        // https://www.wired.com/story/iphone-accelerometer-physics/
        let newXVelocity = velocityXData.last! + accelerometerXData.last! * updatesIntervalOn
        let newYVelocity = velocityYData.last! + accelerometerYData.last! * updatesIntervalOn
        let newZVelocity = velocityZData.last! + accelerometerZData.last! * updatesIntervalOn
        
        velocityXData.append(newXVelocity)
        velocityYData.append(newYVelocity)
        velocityZData.append(newZVelocity)
    }
    
    func calculateVelocityByIntegration(){
        // https://www.nxp.com/docs/en/application-note/AN3397.pdf
        
        let newXVelocity: Double
        let newYVelocity: Double
        let newZVelocity: Double
                
        // velocityXData.append(newXVelocity)
        // velocityYData.append(newYVelocity)
        // velocityZData.append(newZVelocity)
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
        self.accelerationXValueLabel.text = String(format: "%.2f", arguments: [accelerometerXData.last!])
        self.accelerationYValueLabel.text = String(format: "%.2f", arguments: [accelerometerYData.last!])
        self.accelerationZValueLabel.text = String(format: "%.2f", arguments: [accelerometerZData.last!])
        
        self.velocityXValueLabel.text = String(format: "%.2f", arguments: [velocityXData.last!])
        self.velocityYValueLabel.text = String(format: "%.2f", arguments: [velocityYData.last!])
        self.velocityZValueLabel.text = String(format: "%.2f", arguments: [velocityZData.last!])
        
        let velocity = sqrt(pow(velocityXData.last!, 2) + pow(velocityYData.last!, 2) + pow(velocityZData.last!, 2))
        self.speedValueLabel.text = String(format: "%.2f", arguments: [velocity])
    }
    
    func playSound(){
        AudioServicesPlaySystemSound(1052) // SIMToolkitGeneralBeep.caf
    }
    
}
