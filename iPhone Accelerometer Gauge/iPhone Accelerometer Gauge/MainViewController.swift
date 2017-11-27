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
    
    let accelerometerService = AccelerometerService.shared
    var motionManager = CMMotionManager()

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
        
        guard self.motionManager.isDeviceMotionAvailable else {return}
        
        // Updates the interval to avoid 100Hz when the app is paused.
        motionManager.deviceMotionUpdateInterval = playButton.isHidden ? accelerometerService.updatesIntervalOn : accelerometerService.updatesIntervalOff
        
        playButton.isHidden ? recordData() : motionManager.stopDeviceMotionUpdates()
    }
    
    func recordData(){
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
            if let data = data {
                self.updateLabels(data)
            }
        }
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
    
    func updateLabels(_ data: CMDeviceMotion){
        xAxisValueLabel.text = String(format: "%.6f", arguments: [data.userAcceleration.x])
        yAxisValueLabel.text = String(format: "%.6f", arguments: [data.userAcceleration.y])
        zAxisValueLabel.text = String(format: "%.6f", arguments: [data.userAcceleration.z])
    }
    
}
