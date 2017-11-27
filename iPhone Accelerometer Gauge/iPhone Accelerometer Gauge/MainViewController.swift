//
//  MainViewController.swift
//  iPhone Accelerometer Gauge
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
    
    let systemSoundID: SystemSoundID = 1052 // SIMToolkitGeneralBeep.caf
    let updatesIntervalOn = 0.01
    let updatesIntervalOff = 0.1
    let gravity = 9.81

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface() // Include labels and buttons.
    }

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var accelerationTextLabel: UILabel!
    @IBOutlet weak var accelerationValueLabel: UILabel!
    @IBOutlet weak var xAxisTextLabel: UILabel!
    @IBOutlet weak var yAxisTextLabel: UILabel!
    @IBOutlet weak var zAxisTextLabel: UILabel!
    @IBOutlet weak var xAxisValueLabel: UILabel!
    @IBOutlet weak var yAxisValueLabel: UILabel!
    @IBOutlet weak var zAxisValueLabel: UILabel!
    
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
        
        accelerometerXData.removeAll()
        accelerometerYData.removeAll()
        accelerometerZData.removeAll()
        
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
    
    func updateStoredData(_ data: CMDeviceMotion){
        accelerometerXData.append(data.userAcceleration.x * gravity)
        accelerometerYData.append(data.userAcceleration.y * gravity)
        accelerometerZData.append(data.userAcceleration.z * gravity)
    }
    
    func initializeInterface(){
        playButton.isHidden = false
        pauseButton.isHidden = true
        
        accelerationTextLabel.text = "Acceleration"
        xAxisTextLabel.text = "X Axis:"
        yAxisTextLabel.text = "Y Axis:"
        zAxisTextLabel.text = "Z Axis:"
        
        accelerationValueLabel.text = nil
        xAxisValueLabel.text = nil
        yAxisValueLabel.text = nil
        zAxisValueLabel.text = nil
    }
    
    func updateLabels(){
        self.xAxisValueLabel.text = String(accelerometerXData.last!)
        self.yAxisValueLabel.text = String(accelerometerYData.last!)
        self.zAxisValueLabel.text = String(accelerometerZData.last!)
    }
    
    func playSound(){
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
}
