//
//  ViewController.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 16/11/17.
//  Copyright © 2017 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit
import CoreMotion
import Charts
import Surge

import AVFoundation

class ViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    
    var accelerometerXData: [Double] = []           // Sensor values of the accelerometer in the X-Axis.
    var accelerometerYData: [Double] = []           // Sensor values of the accelerometer in the Y-Axis.
    var accelerometerZData: [Double] = []           // Sensor values of the accelerometer in the Z-Axis.
    var accelerometerVerticalData: [Double] = []    // Computed values based on the accelerometer and gravity.
    
    var velocityXData: [Double] = []                // Computed values based on the accelerometer in the X-Axis.
    var velocityYData: [Double] = []                // Computed values based on the accelerometer in the Y-Axis.
    var velocityZData: [Double] = []                // Computed values based on the accelerometer in the Z-Axis.
    var velocityVerticalData: [Double] = []         // Computed values based on the accelerometer and gravity.
    
    var gravityXData: [Double] = []                 // Sensor values of the gravity in the X-Axis.
    var gravityYData: [Double] = []                 // Sensor values of the gravity in the Y-Axis.
    var gravityZData: [Double] = []                 // Sensor values of the gravity in the Z-Axis.

    var accelerometerXDataset: LineChartDataSet = LineChartDataSet()        // Chart dataset of accelerometer values in the X-Axis.
    var accelerometerYDataset: LineChartDataSet = LineChartDataSet()        // Chart dataset of accelerometer values in the Y-Axis.
    var accelerometerZDataset: LineChartDataSet = LineChartDataSet()        // Chart dataset of accelerometer values in the Z-Axis.
    var accelerometerVerticalDataset: LineChartDataSet = LineChartDataSet()   // Chart dataset of accelerometer values based on the acceleration and gravity.
    
    var velocityXDataset: LineChartDataSet = LineChartDataSet()             // Chart dataset of velocity values in the X-Axis.
    var velocityYDataset: LineChartDataSet = LineChartDataSet()             // Chart dataset of velocity values in the Y-Axis.
    var velocityZDataset: LineChartDataSet = LineChartDataSet()             // Chart dataset of velocity values in the Z-Axis.
    var velocityVerticalDataset: LineChartDataSet = LineChartDataSet()        // Chart dataset of velocity values based on the accelerometer and gravity.
    
    var gravityXDataset: LineChartDataSet = LineChartDataSet()              // Chart dataset of the gravity values in the X-Axis.
    var gravityYDataset: LineChartDataSet = LineChartDataSet()              // Chart dataset of the gravity values in the Y-Axis.
    var gravityZDataset: LineChartDataSet = LineChartDataSet()              // Chart dataset of the gravity values in the Z-Axis.
    
    let updatesIntervalOn = 0.01 // 100 Hz (1/100 s)
    let updatesIntervalOff = 0.1 // 10 Hz (1/10 s)
    let gravity = 9.81
    
    var kalman_filter: Kalman_Filter? = nil

    let queue: OperationQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
    }
    
    @IBOutlet weak var playButton: UIButton!                        // Interface play button.
    @IBOutlet weak var pauseButton: UIButton!                       // Interface pause button.
    @IBOutlet weak var segmentedControl: UISegmentedControl!        // Interface segmented control.
    @IBOutlet weak var accelerationLineChartGraph: LineChartView!   // Interface acceleration chart.
    @IBOutlet weak var velocityLineChartGraph: LineChartView!       // Interface velocity chart.
    @IBOutlet weak var gravityLineChartGraph: LineChartView!        // Interface gravity chart.
    
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
        kalman_filter = initializeKalmanFilter()
        
        motionManager.startDeviceMotionUpdates(to: queue) { (data, error) in
            if let data = data {
                self.updateStoredData(data)
            }
        }
    }
    
    func stopRecordData(){
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.stopDeviceMotionUpdates()
        
        OperationQueue.main.addOperation {
            self.accelerationLineChartGraph.notifyDataSetChanged()
            self.velocityLineChartGraph.notifyDataSetChanged()
            self.gravityLineChartGraph.notifyDataSetChanged()
        }

    }
    
    func initializeStoredData(){
        // Clean accelerometer data.
        accelerometerXData.removeAll()
        accelerometerXData.append(0)
        accelerometerYData.removeAll()
        accelerometerYData.append(0)
        accelerometerZData.removeAll()
        accelerometerZData.append(0)
        accelerometerVerticalData.removeAll()
        accelerometerVerticalData.append(0)
        
        // Clean velocity data.
        velocityXData.removeAll()
        velocityXData.append(0)
        velocityYData.removeAll()
        velocityYData.append(0)
        velocityZData.removeAll()
        velocityZData.append(0)
        velocityVerticalData.removeAll()
        velocityVerticalData.append(0)
        
        // Clean gravity data
        gravityXData.removeAll()
        gravityXData.append(0)
        gravityYData.removeAll()
        gravityYData.append(0)
        gravityZData.removeAll()
        gravityZData.append(0)
        
        // Clean acceleration chart dataset
        accelerometerXDataset.values.removeAll()
        accelerometerYDataset.values.removeAll()
        accelerometerZDataset.values.removeAll()
        accelerometerVerticalDataset.values.removeAll()

        // Clean velocity chart dataset
        velocityXDataset.values.removeAll()
        velocityYDataset.values.removeAll()
        velocityZDataset.values.removeAll()
        velocityVerticalDataset.values.removeAll()
        
        // Clean gravity chart dataset
        gravityXDataset.values.removeAll()
        gravityYDataset.values.removeAll()
        gravityZDataset.values.removeAll()
        
        // Clean charts (LineChartView)
        accelerationLineChartGraph.clear()
        velocityLineChartGraph.clear()
        gravityLineChartGraph.clear()
                
        // Create empty chart data
        let accelerationData: LineChartData = LineChartData(dataSets: [accelerometerXDataset, accelerometerYDataset, accelerometerZDataset, accelerometerVerticalDataset])
        let velocityData: LineChartData = LineChartData(dataSets: [velocityXDataset, velocityYDataset, velocityZDataset, velocityVerticalDataset])
        let gravityData: LineChartData = LineChartData(dataSets: [gravityXDataset, gravityYDataset, gravityZDataset])
        
        // Empty data added to the chart
        accelerationLineChartGraph.data = accelerationData
        velocityLineChartGraph.data = velocityData
        gravityLineChartGraph.data = gravityData

    }
    
    func updateStoredData(_ data: CMDeviceMotion){
        // https://www.nxp.com/docs/en/application-note/AN3397.pdf
        // https://www.wired.com/story/iphone-accelerometer-physics/
        
        // Retrive the accelerometer data from the sensor
        var newXAcceleration =  data.userAcceleration.x
        var newYAcceleration =  data.userAcceleration.y
        var newZAcceleration =  data.userAcceleration.z

        // Retrieve the gravity data from the sensor
        let newXGravity = data.gravity.x
        let newYGravity = data.gravity.y
        let newZGravity = data.gravity.z
                
        // Convert the G values to Meters per squared seconds.
        newXAcceleration = newXAcceleration * self.gravity
        newYAcceleration = newYAcceleration * self.gravity
        newZAcceleration = newZAcceleration * self.gravity
        
        // Instant velocity calculation by integration
        let newXVelocity = (accelerometerXData.last! * updatesIntervalOn) + (newXAcceleration - accelerometerXData.last!) * (updatesIntervalOn / 2)
        let newYVelocity = (accelerometerYData.last! * updatesIntervalOn) + (newYAcceleration - accelerometerYData.last!) * (updatesIntervalOn / 2)
        let newZVelocity = (accelerometerZData.last! * updatesIntervalOn) + (newZAcceleration - accelerometerZData.last!) * (updatesIntervalOn / 2)
        
        // Calculate the upward acceleration and velocity using gravity values as normalization vectors.
        let z = Matrix<Double>.init([[newXAcceleration * newXGravity + newYAcceleration * newYGravity + newZAcceleration * newZGravity]])
        let result = kalman_filter!.filter(z)
        
        let newVerticalAcceleration = result.x[1,0]
        let newVerticalVelocity = result.x[0,0]
                        
        // Current velocity by cumulative velocities.
        let currentXVelocity = velocityXData.last! + newXVelocity
        let currentYVelocity = velocityYData.last! + newYVelocity
        let currentZVelocity = velocityZData.last! + newZVelocity
        let currentVerticalVelocity = newVerticalVelocity

        // Data storage
        accelerometerXData.append(newXAcceleration)
        accelerometerYData.append(newYAcceleration)
        accelerometerZData.append(newZAcceleration)
        accelerometerVerticalData.append(newVerticalAcceleration)
        
        velocityXData.append(currentXVelocity)
        velocityYData.append(currentYVelocity)
        velocityZData.append(currentZVelocity)
        velocityVerticalData.append(currentVerticalVelocity)
        
        gravityXData.append(newXGravity)
        gravityYData.append(newYGravity)
        gravityZData.append(newZGravity)
        
        // Current position in graft
        let position: Double = Double(accelerometerXData.count - 1) / 100
        
        // Add one of every four entrances per second.
        guard Int(position*100) % 10 == 0 else { return }
                
        // Acceleration added to Chart
        let entryXAcceleration = ChartDataEntry(x: position, y: newXAcceleration)
        let entryYAcceleration = ChartDataEntry(x: position, y: newYAcceleration)
        let entryZAcceleration = ChartDataEntry(x: position, y: newZAcceleration)
        let entryVerticalAcceleration = ChartDataEntry(x: position, y: newVerticalAcceleration)
        
        accelerationLineChartGraph.data?.addEntry(entryXAcceleration, dataSetIndex: 0)
        accelerationLineChartGraph.data?.addEntry(entryYAcceleration, dataSetIndex: 1)
        accelerationLineChartGraph.data?.addEntry(entryZAcceleration, dataSetIndex: 2)
        accelerationLineChartGraph.data?.addEntry(entryVerticalAcceleration, dataSetIndex: 3)
        
        // Velocity added to Chart
        let entryXVelocity = ChartDataEntry(x: position, y: currentXVelocity)
        let entryYVelocity = ChartDataEntry(x: position, y: currentYVelocity)
        let entryZVelocity = ChartDataEntry(x: position, y: currentZVelocity)
        let entryVerticalVelocity = ChartDataEntry(x: position, y: currentVerticalVelocity)
        
        velocityLineChartGraph.data?.addEntry(entryXVelocity, dataSetIndex: 0)
        velocityLineChartGraph.data?.addEntry(entryYVelocity, dataSetIndex: 1)
        velocityLineChartGraph.data?.addEntry(entryZVelocity, dataSetIndex: 2)
        velocityLineChartGraph.data?.addEntry(entryVerticalVelocity, dataSetIndex: 3)
        
        // Gravity added to the Chart
        let entryXGravity = ChartDataEntry(x: position, y: newXGravity)
        let entryYGravity = ChartDataEntry(x: position, y: newYGravity)
        let entryZGravity = ChartDataEntry(x: position, y: newZGravity)
        
        gravityLineChartGraph.data?.addEntry(entryXGravity, dataSetIndex: 0)
        gravityLineChartGraph.data?.addEntry(entryYGravity, dataSetIndex: 1)
        gravityLineChartGraph.data?.addEntry(entryZGravity, dataSetIndex: 2)
        
        OperationQueue.main.addOperation {
            self.reloadGraphs()
        }

    }
    
    func initializeKalmanFilter() -> Kalman_Filter {
        
        let dt = self.updatesIntervalOn
        
        // State variable mean and covariance.
        let x = Matrix<Double>.init([[0],[0]])
        let P = Matrix<Double>.init([[16,0],[0,16]])
        
        // Process model and noise covariance
        let F = Matrix<Double>.init([[1,dt],[0,1]])
        let Q = Matrix<Double>.init([[0,0],[0,16]])
        
        // Control function
        let B = Matrix<Double>.init([[0,0],[0,0]])
        let u = Matrix<Double>.init([[0],[0]])
        
        // Measurement function and covariance.
        let H = Matrix<Double>.init([[0,1]])
        let R = Matrix<Double>.init([[0.01]])
        
        return Kalman_Filter.init(x, P, F, Q, B, u, H, R)
    }
    
    // INTERFACE UPDATES
    func initializeInterface(){
        // Set play and pause buttons
        playButton.isHidden = false
        pauseButton.isHidden = true
        
        // Set segmented control info
        segmentedControl.setTitle("Acceleration", forSegmentAt: 0)
        segmentedControl.setTitle("Velocity", forSegmentAt: 1)
        segmentedControl.setTitle("Gravity", forSegmentAt: 2)
        segmentedControl.selectedSegmentIndex = 1
        segmentedControlChanged(segmentedControl)

        // Set description of the chart
        accelerationLineChartGraph.chartDescription?.text = "Acceleration by axis"
        velocityLineChartGraph.chartDescription?.text = "Velocity by axis"
        gravityLineChartGraph.chartDescription?.text = "Gravity by axis"
        
        // Set information of the X-Axis accelerometer dataset
        accelerometerXDataset.label = "X - Axis"
        accelerometerXDataset.colors = [NSUIColor.red]
        accelerometerXDataset.setCircleColor(NSUIColor.red)
        accelerometerXDataset.circleRadius = 1
        accelerometerXDataset.circleHoleRadius = 1
        
        // Set information of the Y-Axis accelerometer dataset
        accelerometerYDataset.label = "Y - Axis"
        accelerometerYDataset.colors = [NSUIColor.green]
        accelerometerYDataset.setCircleColor(NSUIColor.green)
        accelerometerYDataset.circleRadius = 1
        accelerometerYDataset.circleHoleRadius = 1
        
        // Set information of the Z-Axis accelerometer dataset
        accelerometerZDataset.label = "Z - Axis"
        accelerometerZDataset.colors = [NSUIColor.blue]
        accelerometerZDataset.setCircleColor(NSUIColor.blue)
        accelerometerZDataset.circleRadius = 1
        accelerometerZDataset.circleHoleRadius = 1
        
        // Set information of the vertical accelerometer dataset
        accelerometerVerticalDataset.label = "Vertical acceleration"
        accelerometerVerticalDataset.colors = [NSUIColor.black]
        accelerometerVerticalDataset.setCircleColor(NSUIColor.black)
        accelerometerVerticalDataset.circleRadius = 1
        accelerometerVerticalDataset.circleHoleRadius = 1
        
        // Set information of the X-Axis velocity dataset
        velocityXDataset.label = "X - Axis"
        velocityXDataset.colors = [NSUIColor.red]
        velocityXDataset.setCircleColor(NSUIColor.red)
        velocityXDataset.circleRadius = 1
        velocityXDataset.circleHoleRadius = 1
        
        // Set information of the Y-Axis velocity dataset
        velocityYDataset.label = "Y - Axis"
        velocityYDataset.colors = [NSUIColor.green]
        velocityYDataset.setCircleColor(NSUIColor.green)
        velocityYDataset.circleRadius = 1
        velocityYDataset.circleHoleRadius = 1
        
        // Set information of the Z-Axis velocity dataset
        velocityZDataset.label = "Z - Axis"
        velocityZDataset.colors = [NSUIColor.blue]
        velocityZDataset.setCircleColor(NSUIColor.blue)
        velocityZDataset.circleRadius = 1
        velocityZDataset.circleHoleRadius = 1
        
        // Set information of the vertical velocity dataset
        velocityVerticalDataset.label = "Vertical velocity"
        velocityVerticalDataset.colors = [NSUIColor.black]
        velocityVerticalDataset.setCircleColor(NSUIColor.black)
        velocityVerticalDataset.circleRadius = 1
        velocityVerticalDataset.circleHoleRadius = 1
        
        // Set information of the X-Axis gravity dataset
        gravityXDataset.label = "X - Axis"
        gravityXDataset.colors = [NSUIColor.red]
        gravityXDataset.setCircleColor(NSUIColor.red)
        gravityXDataset.circleRadius = 1
        gravityXDataset.circleHoleRadius = 1
        
        // Set information of the Y-Axis gravity dataset
        gravityYDataset.label = "Y - Axis"
        gravityYDataset.colors = [NSUIColor.green]
        gravityYDataset.setCircleColor(NSUIColor.green)
        gravityYDataset.circleRadius = 1
        gravityYDataset.circleHoleRadius = 1
        
        // Set information of the Z-Axis gravity dataset
        gravityZDataset.label = "Z - Axis"
        gravityZDataset.colors = [NSUIColor.blue]
        gravityZDataset.setCircleColor(NSUIColor.blue)
        gravityZDataset.circleRadius = 1
        gravityZDataset.circleHoleRadius = 1
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
    
    func reloadGraphs(){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            accelerationLineChartGraph.notifyDataSetChanged()
        case 1:
            velocityLineChartGraph.notifyDataSetChanged()
        case 2:
            gravityLineChartGraph.notifyDataSetChanged()
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
