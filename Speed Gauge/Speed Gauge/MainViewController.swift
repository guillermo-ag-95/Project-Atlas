//
//  MainViewController.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 16/11/17.
//  Copyright © 2017 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit
import CoreMotion
import Charts

import AVFoundation

class MainViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    
    var accelerometerXData: [Double] = []
    var accelerometerYData: [Double] = []
    var accelerometerZData: [Double] = []
    
    var velocityXData: [Double] = []
    var velocityYData: [Double] = []
    var velocityZData: [Double] = []
    
    let updatesIntervalOn = 0.01 // 100 Hz (1/100 s)
    let updatesIntervalOff = 0.1 // 10 Hz (1/10 s)
    let gravity = 9.81

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
    }
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var lineChartGraph: LineChartView!
    
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
            }
        }
    }
    
    func stopRecordData(){
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.stopDeviceMotionUpdates()
        updateGraph()
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
        
        lineChartGraph.clear()
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
        
        // Data storage
        accelerometerXData.append(newXAcceleration)
        accelerometerYData.append(newYAcceleration)
        accelerometerZData.append(newZAcceleration)
        
        velocityXData.append(currentXVelocity)
        velocityYData.append(currentYVelocity)
        velocityZData.append(currentZVelocity)
                
    }
    
    // INTERFACE UPDATES
    func initializeInterface(){
        playButton.isHidden = false
        pauseButton.isHidden = true
        
        lineChartGraph.chartDescription?.text = "Velocity by axis"
    }
    
    func updateGraph(){
        let velocityXdataset: LineChartDataSet = LineChartDataSet()
        let velocityYdataset: LineChartDataSet = LineChartDataSet()
        let velocityZdataset: LineChartDataSet = LineChartDataSet()

        velocityXdataset.label = "X - Axis"
        velocityXdataset.colors = [NSUIColor.red]
        velocityXdataset.setCircleColor(NSUIColor.red)
        velocityXdataset.circleRadius = 1
        velocityXdataset.circleHoleRadius = 1
        
        velocityYdataset.label = "Y - Axis"
        velocityYdataset.colors = [NSUIColor.green]
        velocityYdataset.setCircleColor(NSUIColor.green)
        velocityYdataset.circleRadius = 1
        velocityYdataset.circleHoleRadius = 1
        
        velocityZdataset.label = "Z - Axis"
        velocityZdataset.colors = [NSUIColor.blue]
        velocityZdataset.setCircleColor(NSUIColor.blue)
        velocityZdataset.circleRadius = 1
        velocityZdataset.circleHoleRadius = 1
        
        var x: Double = 0.0
        
        for velocityX in velocityXData {
            let entry = ChartDataEntry(x: x, y: velocityX)
            velocityXdataset.values.append(entry)
            x += updatesIntervalOn
        }
        
        x = 0.0
        
        for velocityY in velocityYData {
            let entry = ChartDataEntry(x: x, y: velocityY)
            velocityYdataset.values.append(entry)
            x += updatesIntervalOn
        }
        
        x = 0.0

        for velocityZ in velocityZData {
            let entry = ChartDataEntry(x: x, y: velocityZ)
            velocityZdataset.values.append(entry)
            x += updatesIntervalOn
        }
        
        let data: LineChartData = LineChartData(dataSets: [velocityXdataset, velocityYdataset, velocityZdataset])
        lineChartGraph.data = data
        
        lineChartGraph.notifyDataSetChanged()
        
    }
    
    // MARK: NAVIGATION
    
    // MARK: - ANCILLARY FUNCTIONS
    
    func playSound(){
        AudioServicesPlaySystemSound(1052) // SIMToolkitGeneralBeep.caf
    }
    
}
