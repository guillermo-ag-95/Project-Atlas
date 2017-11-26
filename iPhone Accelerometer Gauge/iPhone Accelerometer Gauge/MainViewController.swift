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
    
    let systemSoundID: SystemSoundID = 1052 // SIMToolkitGeneralBeep.caf

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
    @IBOutlet weak var ZAxisValueLabel: UILabel!
    
    @IBAction func playPauseButtonPressed(_ sender: UIButton) {
        // Updates which button is shown.
        playButton.isHidden = !playButton.isHidden
        pauseButton.isHidden = !pauseButton.isHidden
        
        // Updates the interval to avoid 100Hz when the app is paused.
        motionManager.accelerometerUpdateInterval = playButton.isHidden ? 0.01 : 0.1
        
        playButton.isHidden ? recordData() : motionManager.stopAccelerometerUpdates()
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
        ZAxisValueLabel.text = nil
    }
    
    func recordData(){
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let data = data{
                self.updateLabels(data)
            }
        }
    }
    
    func updateLabels(_ data: CMAccelerometerData){
        xAxisValueLabel.text = String(data.acceleration.x)
        yAxisValueLabel.text = String(data.acceleration.y)
        ZAxisValueLabel.text = String(data.acceleration.z)
    }
    
    func playSound(){
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
}
