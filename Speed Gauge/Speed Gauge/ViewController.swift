//
//  ViewController.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 16/11/17.
//  Copyright © 2017 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion
import DGCharts
import Surge
import UIKit

import AVFoundation

class ViewController: UIViewController {
	// MARK: - Outlets
	@IBOutlet weak var segmentedControl: UISegmentedControl!		// Interface segmented control.
	@IBOutlet weak var accelerationLineChartGraph: LineChartView!	// Interface acceleration chart.
	@IBOutlet weak var velocityLineChartGraph: LineChartView!		// Interface velocity chart.
	@IBOutlet weak var gravityLineChartGraph: LineChartView!		// Interface gravity chart.
	@IBOutlet weak var actionButton: UIButton!						// Interface play/pause button.
	
	// MARK: - Variables
    var accelerometerXData: [Double] = []           // Sensor values of the accelerometer in the X-Axis.
    var accelerometerYData: [Double] = []           // Sensor values of the accelerometer in the Y-Axis.
    var accelerometerZData: [Double] = []           // Sensor values of the accelerometer in the Z-Axis.
    var accelerometerVerticalData: [Double] = []    // Computed values based on the accelerometer and gravity.
    
    var gyroXData: [Double] = []                    // Sensor values of the gyro in the X-Axis.
    var gyroYData: [Double] = []                    // Sensor values of the gyro in the Y-Axis.
    var gyroZData: [Double] = []                    // Sensor values of the gyro in the Z-Axis.

    var velocityXData: [Double] = []                // Computed values based on the accelerometer in the X-Axis.
    var velocityYData: [Double] = []                // Computed values based on the accelerometer in the Y-Axis.
    var velocityZData: [Double] = []                // Computed values based on the accelerometer in the Z-Axis.
    var velocityVerticalData: [Double] = []         // Computed values based on the accelerometer and gravity.
    var velocityVerticalFixedData: [Double] = []    // Fixed computed values based on the accelerometer and gravity.
    
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
    
    var maxVelocities: [Double] = []
    var meanVelocities: [Double] = []
    
	let updatesIntervalOn = 0.01 // 100 Hz (1/100 s)
    let updatesIntervalOff = 0.1 // 10 Hz (1/10 s)
    let gravity = 9.81
    
    let queue: OperationQueue = OperationQueue()
	var motionManager = CMMotionManager()
	
	// MARK: - States
	var isPaused = true {
		didSet {
			setupButtons()
		}
	}
	
	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupNavigationBar()
		setupHeader()
		setupCharts()
		setupButtons()
	}
	
	// MARK: - Setup functions
	func setupNavigationBar() {
		guard let navigationController = navigationController else { return }
		navigationController.navigationBar.topItem?.title = LocalizedKeys.Common.graphs
		navigationController.navigationBar.topItem?.rightBarButtonItem?.title = LocalizedKeys.Common.results
	}
	
	func setupHeader() {
		segmentedControl.setTitle(LocalizedKeys.Acceleration.title, forSegmentAt: 0)
		segmentedControl.setTitle(LocalizedKeys.Velocity.title, forSegmentAt: 1)
		segmentedControl.setTitle(LocalizedKeys.Gravity.title, forSegmentAt: 2)
		segmentedControl.selectedSegmentIndex = 1
		segmentedControlChanged(segmentedControl)
	}
	
	func setupCharts() {
		accelerationLineChartGraph.chartDescription.text = LocalizedKeys.Acceleration.byAxis
		velocityLineChartGraph.chartDescription.text = LocalizedKeys.Velocity.byAxis
		gravityLineChartGraph.chartDescription.text = LocalizedKeys.Gravity.byAxis
		
		setupDataSet(accelerometerXDataset, label: LocalizedKeys.Common.xAxis, color: .appRed)
		setupDataSet(accelerometerYDataset, label: LocalizedKeys.Common.yAxis, color: .appGreen)
		setupDataSet(accelerometerZDataset, label: LocalizedKeys.Common.zAxis, color: .appBlue)
		setupDataSet(accelerometerVerticalDataset, label: LocalizedKeys.Acceleration.vertical, color: .appBlack)
		
		setupDataSet(velocityXDataset, label: LocalizedKeys.Common.xAxis, color: .appRed)
		setupDataSet(velocityYDataset, label: LocalizedKeys.Common.yAxis, color: .appGreen)
		setupDataSet(velocityZDataset, label: LocalizedKeys.Common.zAxis, color: .appBlue)
		setupDataSet(velocityVerticalDataset, label: LocalizedKeys.Velocity.vertical, color: .appBlack)
		
		setupDataSet(gravityXDataset, label: LocalizedKeys.Common.xAxis, color: .appRed)
		setupDataSet(gravityYDataset, label: LocalizedKeys.Common.yAxis, color: .appGreen)
		setupDataSet(gravityZDataset, label: LocalizedKeys.Common.zAxis, color: .appBlue)
	}
	
	func setupDataSet(_ dataSet: LineChartDataSet, label: String, color: UIColor, pointSize: CGFloat = 1) {
		dataSet.label = label
		dataSet.colors = [color]
		dataSet.setCircleColor(color)
		dataSet.circleRadius = pointSize
		dataSet.circleHoleRadius = pointSize
	}
	
	func setupButtons() {
		let actionButtonImage: UIImage? = isPaused ? .systemPlayFill : .systemPauseFill
		actionButton.setImage(actionButtonImage, for: .normal)
	}
	
	// MARK: - Actions
	@IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
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
	
    @IBAction func actionButtonPressed(_ sender: UIButton) {
		let willPause = !isPaused
		self.isPaused = willPause
        
        // Updates the interval to avoid 100Hz when the app is paused.
		let deviceMotionUpdateInterval = willPause ? self.updatesIntervalOff : self.updatesIntervalOn
		motionManager.deviceMotionUpdateInterval = deviceMotionUpdateInterval
		
		willPause ? stopRecordData() : startRecordData()
    }
    
	// MARK: - Data recording
    func startRecordData() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        setupStoredData()
        
        motionManager.startDeviceMotionUpdates(to: queue) { [weak self] (data, error) in
            if let data = data {
				self?.updateStoredData(data)
            }
        }
    }
    
    func stopRecordData() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.stopDeviceMotionUpdates()
        
        let slope = velocityVerticalData.last! / Double(velocityVerticalData.count)

        // Remove lineally the slope from the vertical acceleration.
		velocityVerticalFixedData = velocityVerticalData.enumerated().map({ index, element in
			let result = element - slope * Double(index)
			return result
		})

        // Clear and update vertical velocity chart with new data
        velocityLineChartGraph.data?.dataSets[3].clear()

        for i in 0..<velocityVerticalFixedData.count {
            if i % 10 == 0 {
                let position = Double(i) / 100
                let element = velocityVerticalFixedData[i]
                let entryVerticalVelocity = ChartDataEntry(x: position, y: element)
				velocityLineChartGraph.data?.appendEntry(entryVerticalVelocity, toDataSet: 3)
            }
        }

        // Calculate when the rep starts, ends,  max velocity and mean velocity.
        var maximum = 0.0
        var startingPoints: [Int] = []
        var endingPoints: [Int] = []

        maxVelocities = []
        meanVelocities = []

        for i in 0..<velocityVerticalFixedData.count {
            let element = abs(velocityVerticalFixedData[i]) < 0.1 ? 0.0 : velocityVerticalFixedData[i]

            if element > 0.0 && maximum == 0.0 { startingPoints.append(i) }     // Save the starting point of the rep.
            if element > 0.0 && element > maximum { maximum = element }         // Update the maximum velocity if needed.

            if element == 0.0 && maximum != 0.0 {
                endingPoints.append(i)  // Save the ending point.

                // Check that the interval is big enough
                if (endingPoints.last! - startingPoints.last! < 30) {
                    // If not,
                    startingPoints.removeLast()
                    endingPoints.removeLast()
                    maximum = 0.0
                } else {
                    // If so, go on
                    maxVelocities.append(maximum)   // Save the max velocity of the rep.
                    maximum = 0.0                   // Reset the maximum velocity.

                    let repVelocities = velocityVerticalFixedData.suffix(from: startingPoints.last!).prefix(upTo: endingPoints.last!)
                    let meanVelocity = Surge.mean(Array(repVelocities))

                    meanVelocities.append(meanVelocity)
                }
            }
        }
        
        // Update charts.
        accelerationLineChartGraph.notifyDataSetChanged()
        velocityLineChartGraph.notifyDataSetChanged()
        gravityLineChartGraph.notifyDataSetChanged()
        
    }
    
	// MARK: - Data management
    func setupStoredData() {
        // Clean accelerometer data.
		restoreData(&accelerometerXData)
		restoreData(&accelerometerYData)
		restoreData(&accelerometerZData)
		restoreData(&accelerometerVerticalData)
        
        // Clean gyro data.
		restoreData(&gyroXData)
		restoreData(&gyroYData)
		restoreData(&gyroZData)
		
        // Clean velocity data.
		restoreData(&velocityXData)
		restoreData(&velocityYData)
		restoreData(&velocityZData)
		restoreData(&velocityVerticalData)
		restoreData(&velocityVerticalFixedData, keepsEmpty: true)
        
        // Clean gravity data
		restoreData(&gravityXData)
		restoreData(&gravityYData)
		restoreData(&gravityZData)
        
        // Clean acceleration chart dataset
		restoreDataSet(accelerometerXDataset)
		restoreDataSet(accelerometerYDataset)
		restoreDataSet(accelerometerZDataset)
		restoreDataSet(accelerometerVerticalDataset)
        
        // Clean velocity chart dataset
		restoreDataSet(velocityXDataset)
		restoreDataSet(velocityYDataset)
		restoreDataSet(velocityZDataset)
		restoreDataSet(velocityVerticalDataset)

        // Clean gravity chart dataset
		restoreDataSet(gravityXDataset)
		restoreDataSet(gravityYDataset)
		restoreDataSet(gravityZDataset)

        // Clean charts (LineChartView)
		restoreChart(accelerationLineChartGraph)
		restoreChart(velocityLineChartGraph)
		restoreChart(gravityLineChartGraph)
        
        // Create empty chart data
        let accelerationData: LineChartData = LineChartData(
			dataSets: [
				accelerometerXDataset,
				accelerometerYDataset,
				accelerometerZDataset,
				accelerometerVerticalDataset
			]
		)
		
        let velocityData: LineChartData = LineChartData(
			dataSets: [
				velocityXDataset,
				velocityYDataset,
				velocityZDataset,
				velocityVerticalDataset
			]
		)
		
        let gravityData: LineChartData = LineChartData(
			dataSets: [
				gravityXDataset,
				gravityYDataset,
				gravityZDataset
			]
		)
        
        // Empty data added to the chart
        accelerationLineChartGraph.data = accelerationData
        velocityLineChartGraph.data = velocityData
        gravityLineChartGraph.data = gravityData
        
        // Update charts.
        accelerationLineChartGraph.notifyDataSetChanged()
        velocityLineChartGraph.notifyDataSetChanged()
        gravityLineChartGraph.notifyDataSetChanged()
    }
	
	func restoreData(_ data: inout Array<Double>, keepsEmpty: Bool = false) {
		data.removeAll()
		
		guard !keepsEmpty else { return }
		data.append(.zero)
	}
	
	func restoreDataSet(_ dataSet: LineChartDataSet, keepsEmpty: Bool = false) {
		// keepingCapacity must be true to keep dataset style.
		dataSet.removeAll(keepingCapacity: true)
		
		guard !keepsEmpty else { return }
		dataSet.append(.init(x: .zero, y: .zero))
	}
	
	func restoreChart(_ chart: LineChartView) {
		chart.clear()
	}
    
    func updateStoredData(_ data: CMDeviceMotion) {
        // https://www.nxp.com/docs/en/application-note/AN3397.pdf
        // https://www.wired.com/story/iphone-accelerometer-physics/
        
        // Retrieve the accelerometer data from the sensor
        var newXAcceleration =  data.userAcceleration.x
        var newYAcceleration =  data.userAcceleration.y
        var newZAcceleration =  data.userAcceleration.z
        
        // Retrieve the gravity data from the sensor
        let newXGravity = data.gravity.x
        let newYGravity = data.gravity.y
        let newZGravity = data.gravity.z
        
        // Retrieve the gyro data from the sensor
        let newXGyro = data.rotationRate.x
        let newYGyro = data.rotationRate.y
        let newZGyro = data.rotationRate.z

        // Compute scalar projection of the acceleration vector onto the gravity vector
        let gravityModule = sqrt(pow(newXGravity, 2) + pow(newYGravity, 2) + pow(newZGravity, 2))
        let accelerationVector = [newXAcceleration, newYAcceleration, newZAcceleration]
        let gravityVector = [newXGravity, newYGravity, newZGravity]
		let dotProduct = Surge.dot(gravityVector, accelerationVector)
		let scalarProjection = gravityVector.map { dotProduct / pow(gravityModule, 2) * $0 * self.gravity }
        
        // Convert the G values to Meters per squared seconds.
        newXAcceleration = newXAcceleration * self.gravity
        newYAcceleration = newYAcceleration * self.gravity
        newZAcceleration = newZAcceleration * self.gravity
        
        // Instant velocity calculation by integration
        let newXVelocity = (accelerometerXData.last! * updatesIntervalOn) + (newXAcceleration - accelerometerXData.last!) * (updatesIntervalOn / 2)
        let newYVelocity = (accelerometerYData.last! * updatesIntervalOn) + (newYAcceleration - accelerometerYData.last!) * (updatesIntervalOn / 2)
        let newZVelocity = (accelerometerZData.last! * updatesIntervalOn) + (newZAcceleration - accelerometerZData.last!) * (updatesIntervalOn / 2)
        
        // Compute vertical acceleration and velocity
        let newVerticalAcceleration = sign(dotProduct) * sqrt(pow(scalarProjection[0], 2) + pow(scalarProjection[1], 2) + pow(scalarProjection[2], 2))
        let newVerticalVelocity =
            (accelerometerVerticalData.last! * updatesIntervalOn) + (newVerticalAcceleration - accelerometerVerticalData.last!) * (updatesIntervalOn / 2)
        
        // Current velocity by cumulative velocities.
        let currentXVelocity = velocityXData.last! + newXVelocity
        let currentYVelocity = velocityYData.last! + newYVelocity
        let currentZVelocity = velocityZData.last! + newZVelocity
        let currentVerticalVelocity = velocityVerticalData.last! + newVerticalVelocity

        // Data storage
        accelerometerXData.append(newXAcceleration)
        accelerometerYData.append(newYAcceleration)
        accelerometerZData.append(newZAcceleration)
        accelerometerVerticalData.append(newVerticalAcceleration)
        
        gyroYData.append(newXGyro)
        gyroYData.append(newYGyro)
        gyroZData.append(newZGyro)

        velocityXData.append(currentXVelocity)
        velocityYData.append(currentYVelocity)
        velocityZData.append(currentZVelocity)
        velocityVerticalData.append(currentVerticalVelocity)
        
        gravityXData.append(newXGravity)
        gravityYData.append(newYGravity)
        gravityZData.append(newZGravity)

        // Current position in graft
        let position: Double = Double(accelerometerXData.count - 1) / 100

        // Add one of every ten entrances per second. You need to use round(). If not, 201 is casted as 200, thus true.
        guard Int(round(position * 100)) % 10 == 0 else { return }
                
        // Acceleration added to Chart
        let entryXAcceleration = ChartDataEntry(x: position, y: newXAcceleration)
        let entryYAcceleration = ChartDataEntry(x: position, y: newYAcceleration)
        let entryZAcceleration = ChartDataEntry(x: position, y: newZAcceleration)
        let entryVerticalAcceleration = ChartDataEntry(x: position, y: newVerticalAcceleration)
        
		accelerationLineChartGraph.data?.appendEntry(entryXAcceleration, toDataSet: 0)
		accelerationLineChartGraph.data?.appendEntry(entryYAcceleration, toDataSet: 1)
		accelerationLineChartGraph.data?.appendEntry(entryZAcceleration, toDataSet: 2)
		accelerationLineChartGraph.data?.appendEntry(entryVerticalAcceleration, toDataSet: 3)
        
        // Velocity added to Chart
        let entryXVelocity = ChartDataEntry(x: position, y: currentXVelocity)
        let entryYVelocity = ChartDataEntry(x: position, y: currentYVelocity)
        let entryZVelocity = ChartDataEntry(x: position, y: currentZVelocity)
        let entryVerticalVelocity = ChartDataEntry(x: position, y: currentVerticalVelocity)
        
		velocityLineChartGraph.data?.appendEntry(entryXVelocity, toDataSet: 0)
        velocityLineChartGraph.data?.appendEntry(entryYVelocity, toDataSet: 1)
        velocityLineChartGraph.data?.appendEntry(entryZVelocity, toDataSet: 2)
        velocityLineChartGraph.data?.appendEntry(entryVerticalVelocity, toDataSet: 3)
        
        // Gravity added to the Chart
        let entryXGravity = ChartDataEntry(x: position, y: newXGravity)
        let entryYGravity = ChartDataEntry(x: position, y: newYGravity)
        let entryZGravity = ChartDataEntry(x: position, y: newZGravity)
        
        gravityLineChartGraph.data?.appendEntry(entryXGravity, toDataSet: 0)
        gravityLineChartGraph.data?.appendEntry(entryYGravity, toDataSet: 1)
        gravityLineChartGraph.data?.appendEntry(entryZGravity, toDataSet: 2)
		
		OperationQueue.main.addOperation { [weak self] in
            self?.reloadGraphs()
        }
    }
    
	func reloadGraphs() {
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
    
    // MARK: - Navigations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		segue.destination.navigationItem.title = LocalizedKeys.Common.results
        
        let repetitionTableViewController = segue.destination as! RepetitionTableViewController
        
        repetitionTableViewController.maxVelocities = maxVelocities
        repetitionTableViewController.meanVelocities = meanVelocities
    }
    
    // MARK: - Ancillary functions
    private func printAccelerationData() {
        print("X-Acceleration")
        print(accelerometerXData)
        print("Y-Acceleration")
        print(accelerometerYData)
        print("Z-Acceleration")
        print(accelerometerZData)
    }
    
    private func playSound() {
        AudioServicesPlaySystemSound(1052) // SIMToolkitGeneralBeep.caf
    }
}
