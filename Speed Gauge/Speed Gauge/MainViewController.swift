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
    
    var gravityXData: [Double] = []
    var gravityYData: [Double] = []
    var gravityZData: [Double] = []

    var accelerometerXDataset: LineChartDataSet = LineChartDataSet()
    var accelerometerYDataset: LineChartDataSet = LineChartDataSet()
    var accelerometerZDataset: LineChartDataSet = LineChartDataSet()
    
    var velocityXDataset: LineChartDataSet = LineChartDataSet()
    var velocityYDataset: LineChartDataSet = LineChartDataSet()
    var velocityZDataset: LineChartDataSet = LineChartDataSet()
    
    var gravityXDataset: LineChartDataSet = LineChartDataSet()
    var gravityYDataset: LineChartDataSet = LineChartDataSet()
    var gravityZDataset: LineChartDataSet = LineChartDataSet()

    let updatesIntervalOn = 0.01 // 100 Hz (1/100 s)
    let updatesIntervalOff = 0.1 // 10 Hz (1/10 s)
    let gravity = 9.81

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
    }
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var accelerationLineChartGraph: LineChartView!
    @IBOutlet weak var velocityLineChartGraph: LineChartView!
    @IBOutlet weak var gravityLineChartGraph: LineChartView!
    
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
        // Clean accelerometer data.
        accelerometerXData.removeAll()
        accelerometerXData.append(0)
        accelerometerYData.removeAll()
        accelerometerYData.append(0)
        accelerometerZData.removeAll()
        accelerometerZData.append(0)
        
        // Clean velocity data.
        velocityXData.removeAll()
        velocityXData.append(0)
        velocityYData.removeAll()
        velocityYData.append(0)
        velocityZData.removeAll()
        velocityZData.append(0)
        
        // Clean gravity data
        gravityXData.removeAll()
        gravityXData.append(0)
        gravityYData.removeAll()
        gravityYData.append(0)
        gravityZData.removeAll()
        gravityZData.append(0)
        
        // Clean acceleration LineChartDataSet
        accelerometerXDataset.values.removeAll()
        accelerometerYDataset.values.removeAll()
        accelerometerZDataset.values.removeAll()

        // Clean velocity LineChartDataSet
        velocityXDataset.values.removeAll()
        velocityYDataset.values.removeAll()
        velocityZDataset.values.removeAll()
        
        // Clean gravity LineChartDataSet
        gravityXDataset.values.removeAll()
        gravityYDataset.values.removeAll()
        gravityZDataset.values.removeAll()

        // Clean charts (LineChartView)
        accelerationLineChartGraph.clear()
        velocityLineChartGraph.clear()
        gravityLineChartGraph.clear()
    }
    
    func updateStoredData(_ data: CMDeviceMotion){
        // https://www.nxp.com/docs/en/application-note/AN3397.pdf
        // https://www.wired.com/story/iphone-accelerometer-physics/
        
        // The accelerometer sensor seems to be inverted, so we need to change its sign
        let newXAcceleration =  -data.userAcceleration.x * self.gravity
        let newYAcceleration =  -data.userAcceleration.y * self.gravity
        let newZAcceleration =  -data.userAcceleration.z * self.gravity
        
        let newXGravity = data.gravity.x
        let newYGravity = data.gravity.y
        let newZGravity = data.gravity.z
        
        // Instant velocity calculation by integration
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
        
        gravityXData.append(newXGravity)
        gravityYData.append(newYGravity)
        gravityZData.append(newZGravity)
        
        // Current position in graft
        let position: Double = Double(accelerometerXData.count - 1) / 100
        
        // Acceleration added to Chart Dataset
        let entryXAcceleration = ChartDataEntry(x: position, y: newXAcceleration)
        let entryYAcceleration = ChartDataEntry(x: position, y: newYAcceleration)
        let entryZAcceleration = ChartDataEntry(x: position, y: newZAcceleration)
        
        accelerometerXDataset.values.append(entryXAcceleration)
        accelerometerYDataset.values.append(entryYAcceleration)
        accelerometerZDataset.values.append(entryZAcceleration)
        
        // Velocity added to Chart Dataset
        let entryXVelocity = ChartDataEntry(x: position, y: currentXVelocity)
        let entryYVelocity = ChartDataEntry(x: position, y: currentYVelocity)
        let entryZVelocity = ChartDataEntry(x: position, y: currentZVelocity)
        
        velocityXDataset.values.append(entryXVelocity)
        velocityYDataset.values.append(entryYVelocity)
        velocityZDataset.values.append(entryZVelocity)
        
        // Gravity added to the Chart Dataset
        let entryXGravity = ChartDataEntry(x: position, y: newXGravity)
        let entryYGravity = ChartDataEntry(x: position, y: newYGravity)
        let entryZGravity = ChartDataEntry(x: position, y: newZGravity)
        
        gravityXDataset.values.append(entryXGravity)
        gravityYDataset.values.append(entryYGravity)
        gravityZDataset.values.append(entryZGravity)

    }
    
    // INTERFACE UPDATES
    func initializeInterface(){
        playButton.isHidden = false
        pauseButton.isHidden = true
        
        segmentedControl.setTitle("Acceleration", forSegmentAt: 0)
        segmentedControl.setTitle("Velocity", forSegmentAt: 1)
        segmentedControl.setTitle("Gravity", forSegmentAt: 2)
        segmentedControl.selectedSegmentIndex = 1

        accelerationLineChartGraph.chartDescription?.text = "Acceleration by axis"
        velocityLineChartGraph.chartDescription?.text = "Velocity by axis"
        gravityLineChartGraph.chartDescription?.text = "Gravity by axis"
        
        accelerometerXDataset.label = "X - Axis"
        accelerometerXDataset.colors = [NSUIColor.red]
        accelerometerXDataset.setCircleColor(NSUIColor.red)
        accelerometerXDataset.circleRadius = 1
        accelerometerXDataset.circleHoleRadius = 1
        
        accelerometerYDataset.label = "Y - Axis"
        accelerometerYDataset.colors = [NSUIColor.green]
        accelerometerYDataset.setCircleColor(NSUIColor.green)
        accelerometerYDataset.circleRadius = 1
        accelerometerYDataset.circleHoleRadius = 1
        
        accelerometerZDataset.label = "Z - Axis"
        accelerometerZDataset.colors = [NSUIColor.blue]
        accelerometerZDataset.setCircleColor(NSUIColor.blue)
        accelerometerZDataset.circleRadius = 1
        accelerometerZDataset.circleHoleRadius = 1
        
        velocityXDataset.label = "X - Axis"
        velocityXDataset.colors = [NSUIColor.red]
        velocityXDataset.setCircleColor(NSUIColor.red)
        velocityXDataset.circleRadius = 1
        velocityXDataset.circleHoleRadius = 1
        
        velocityYDataset.label = "Y - Axis"
        velocityYDataset.colors = [NSUIColor.green]
        velocityYDataset.setCircleColor(NSUIColor.green)
        velocityYDataset.circleRadius = 1
        velocityYDataset.circleHoleRadius = 1
        
        velocityZDataset.label = "Z - Axis"
        velocityZDataset.colors = [NSUIColor.blue]
        velocityZDataset.setCircleColor(NSUIColor.blue)
        velocityZDataset.circleRadius = 1
        velocityZDataset.circleHoleRadius = 1
        
        gravityXDataset.label = "X - Axis"
        gravityXDataset.colors = [NSUIColor.red]
        gravityXDataset.setCircleColor(NSUIColor.red)
        gravityXDataset.circleRadius = 1
        gravityXDataset.circleHoleRadius = 1
        
        gravityYDataset.label = "Y - Axis"
        gravityYDataset.colors = [NSUIColor.green]
        gravityYDataset.setCircleColor(NSUIColor.green)
        gravityYDataset.circleRadius = 1
        gravityYDataset.circleHoleRadius = 1
        
        gravityZDataset.label = "Z - Axis"
        gravityZDataset.colors = [NSUIColor.blue]
        gravityZDataset.setCircleColor(NSUIColor.blue)
        gravityZDataset.circleRadius = 1
        gravityZDataset.circleHoleRadius = 1
    }
    
    func updateGraph(){
            let accelerationData: LineChartData = LineChartData(dataSets: [accelerometerXDataset, accelerometerYDataset, accelerometerZDataset])
            accelerationLineChartGraph.data = accelerationData
            accelerationLineChartGraph.notifyDataSetChanged()
            
            let velocityData: LineChartData = LineChartData(dataSets: [velocityXDataset, velocityYDataset, velocityZDataset])
            velocityLineChartGraph.data = velocityData
            velocityLineChartGraph.notifyDataSetChanged()
            
            let gravityData: LineChartData = LineChartData(dataSets: [gravityXDataset, gravityYDataset, gravityZDataset])
            gravityLineChartGraph.data = gravityData
            gravityLineChartGraph.notifyDataSetChanged()
            
            segmentedControlChanged(segmentedControl)
        
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            accelerationLineChartGraph.isHidden = false
            velocityLineChartGraph.isHidden = true
            gravityLineChartGraph.isHidden = true
        case 1:
            accelerationLineChartGraph.isHidden = true
            velocityLineChartGraph.isHidden = false
            gravityLineChartGraph.isHidden = true
        case 2:
            accelerationLineChartGraph.isHidden = true
            velocityLineChartGraph.isHidden = true
            gravityLineChartGraph.isHidden = false
        default:
            break
        }
    }
    
    // MARK: NAVIGATION
    
    // MARK: - ANCILLARY FUNCTIONS
    
    func printAccelerationData(){
        print("X-Acceleration")
        print(accelerometerXData)
        print("Y-Acceleration")
        print(accelerometerYData)
        print("Z-Acceleration")
        print(accelerometerZData)
    }
    
    func playSound(){
        AudioServicesPlaySystemSound(1052) // SIMToolkitGeneralBeep.caf
    }
    
}
