//
//  ChartViewController.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 16/11/17.
//  Copyright © 2017 Guillermo Alcalá Gamero. All rights reserved.
//

import AVFoundation
import DGCharts
import Surge
import UIKit

class ChartViewController: UIViewController {
	// MARK: - Outlets
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBOutlet weak var lineChartView: LineChartView!
	@IBOutlet weak var actionButton: UIButton!
	
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
	let motionService: DeviceMotionServiceProtocol = CoreMotionService()
	
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
		segmentedControl.setTitle(GraphCharts.ACCELERATION.title, forSegmentAt: GraphCharts.ACCELERATION.rawValue)
		segmentedControl.setTitle(GraphCharts.VELOCITY.title, forSegmentAt: GraphCharts.VELOCITY.rawValue)
		segmentedControl.setTitle(GraphCharts.GRAVITY.title, forSegmentAt: GraphCharts.GRAVITY.rawValue)
		segmentedControl.selectedSegmentIndex = GraphCharts.VELOCITY.rawValue
	}
	
	func setupCharts() {
		lineChartView.chartDescription.text = GraphCharts(rawValue: segmentedControl.selectedSegmentIndex)?.description
		
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
		reloadChart()
	}
	
    @IBAction func actionButtonPressed(_ sender: UIButton) {
		let willPause = !isPaused
		self.isPaused = willPause
        
        // Updates the interval to avoid 100Hz when the app is paused.
		let deviceMotionUpdateInterval = willPause ? self.updatesIntervalOff : self.updatesIntervalOn
		motionService.deviceMotionUpdateInterval = deviceMotionUpdateInterval
		
		// Trigger haptic notification
		vibrateDevice()
		
		willPause ? stopRecordData() : startRecordData()
    }
    
	// MARK: - Data recording
    func startRecordData() {
		guard motionService.isDeviceMotionAvailable else { return }
        
        setupStoredData()
		
		motionService.startDeviceMotionUpdates(to: queue) { [weak self] model in
			self?.updateStoredData(model)
		} failure: { [weak self] error in
			self?.stopRecordData()
		}
    }
    
    func stopRecordData() {
        guard motionService.isDeviceMotionAvailable else { return }
		motionService.stopDeviceMotionUpdates()
        
		let lastVelocityVerticalData = velocityVerticalData.last ?? .zero
        let slope = lastVelocityVerticalData / Double(velocityVerticalData.count)

        // Remove lineally the slope from the vertical acceleration.
		velocityVerticalFixedData = velocityVerticalData.enumerated().map({ index, element in
			let result = element - slope * Double(index)
			return result
		})

        // Clear and update vertical velocity chart with new data
		restoreDataSet(velocityVerticalDataset, keepsEmpty: true)
		
        for i in 0..<velocityVerticalFixedData.count {
            if i % 10 == 0 {
                let position = Double(i) / 100
                let element = velocityVerticalFixedData[i]
                let entryVerticalVelocity = ChartDataEntry(x: position, y: element)
				velocityVerticalDataset.append(entryVerticalVelocity)
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
				let startingPoint = startingPoints.last ?? .zero
				let endingPoint = endingPoints.last ?? .zero
				
                if (endingPoint - startingPoint < 30) {
                    // If not,
                    startingPoints.removeLast()
                    endingPoints.removeLast()
                    maximum = 0.0
                } else {
                    // If so, go on
                    maxVelocities.append(maximum)   // Save the max velocity of the rep.
                    maximum = 0.0                   // Reset the maximum velocity.

					let repVelocities = velocityVerticalFixedData.suffix(from: startingPoint).prefix(upTo: endingPoint)
                    let meanVelocity = Surge.mean(Array(repVelocities))

                    meanVelocities.append(meanVelocity)
                }
            }
        }
		
		reloadChart()
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

        // Clean chart (LineChartView)
		restoreChart(lineChartView)
        
        // Empty data added to the chart
		reloadChart()
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
    
	func updateStoredData(_ data: DeviceMotionServiceModel) {
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
		let lastAccelerometerXData = accelerometerXData.last ?? .zero
		let lastAccelerometerYData = accelerometerYData.last ?? .zero
		let lastAccelerometerZData = accelerometerZData.last ?? .zero
		
        let newXVelocity = (lastAccelerometerXData * updatesIntervalOn) + (newXAcceleration - lastAccelerometerXData) * (updatesIntervalOn / 2)
        let newYVelocity = (lastAccelerometerYData * updatesIntervalOn) + (newYAcceleration - lastAccelerometerYData) * (updatesIntervalOn / 2)
        let newZVelocity = (lastAccelerometerZData * updatesIntervalOn) + (newZAcceleration - lastAccelerometerZData) * (updatesIntervalOn / 2)
        
        // Compute vertical acceleration and velocity
		let lastAccelerometerVerticalData = accelerometerVerticalData.last ?? .zero
		
        let newVerticalAcceleration = sign(dotProduct) * sqrt(pow(scalarProjection[0], 2) + pow(scalarProjection[1], 2) + pow(scalarProjection[2], 2))
        let newVerticalVelocity =
            (lastAccelerometerVerticalData * updatesIntervalOn) + (newVerticalAcceleration - lastAccelerometerVerticalData) * (updatesIntervalOn / 2)
        
        // Current velocity by cumulative velocities.
		let lastVelocityXData = velocityXData.last ?? .zero
		let lastVelocityYData = velocityYData.last ?? .zero
		let lastVelocityZData = velocityZData.last ?? .zero
		let lastVelocityVerticalData = velocityVerticalData.last ?? .zero
		
        let currentXVelocity = lastVelocityXData + newXVelocity
        let currentYVelocity = lastVelocityYData + newYVelocity
        let currentZVelocity = lastVelocityZData + newZVelocity
        let currentVerticalVelocity = lastVelocityVerticalData + newVerticalVelocity

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
		
		accelerometerXDataset.append(entryXAcceleration)
		accelerometerYDataset.append(entryYAcceleration)
		accelerometerZDataset.append(entryZAcceleration)
		accelerometerVerticalDataset.append(entryVerticalAcceleration)
        
        // Velocity added to Chart
        let entryXVelocity = ChartDataEntry(x: position, y: currentXVelocity)
        let entryYVelocity = ChartDataEntry(x: position, y: currentYVelocity)
        let entryZVelocity = ChartDataEntry(x: position, y: currentZVelocity)
        let entryVerticalVelocity = ChartDataEntry(x: position, y: currentVerticalVelocity)
        
		velocityXDataset.append(entryXVelocity)
		velocityYDataset.append(entryYVelocity)
		velocityZDataset.append(entryZVelocity)
		velocityVerticalDataset.append(entryVerticalVelocity)
        
        // Gravity added to the Chart
        let entryXGravity = ChartDataEntry(x: position, y: newXGravity)
        let entryYGravity = ChartDataEntry(x: position, y: newYGravity)
        let entryZGravity = ChartDataEntry(x: position, y: newZGravity)
        
		gravityXDataset.append(entryXGravity)
		gravityYDataset.append(entryYGravity)
		gravityZDataset.append(entryZGravity)
		
		OperationQueue.main.addOperation { [weak self] in
			self?.reloadChart()
        }
    }
	
	func reloadChart() {
		let dataSets: [any ChartDataSetProtocol]
		
		switch segmentedControl.selectedSegmentIndex {
		case GraphCharts.ACCELERATION.rawValue:
			dataSets = [
				accelerometerXDataset,
				accelerometerYDataset,
				accelerometerZDataset,
				accelerometerVerticalDataset
			]
		case GraphCharts.VELOCITY.rawValue:
			dataSets = [
				velocityXDataset,
				velocityYDataset,
				velocityZDataset,
				velocityVerticalDataset
			]
		case GraphCharts.GRAVITY.rawValue:
			dataSets = [
				gravityXDataset,
				gravityYDataset,
				gravityZDataset
			]
		default:
			dataSets = []
		}
		
		let lineChartData = LineChartData(dataSets: dataSets)
		lineChartView.data = lineChartData
		lineChartView.notifyDataSetChanged()
	}
    
    // MARK: - Navigations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		segue.destination.navigationItem.title = LocalizedKeys.Common.results
        
        let resultsTableViewController = segue.destination as? ResultsTableViewController
        
        resultsTableViewController?.maxVelocities = maxVelocities
        resultsTableViewController?.meanVelocities = meanVelocities
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
}
