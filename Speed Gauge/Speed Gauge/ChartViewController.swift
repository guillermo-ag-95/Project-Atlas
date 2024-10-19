//
//  ChartViewController.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 16/11/17.
//  Copyright © 2017 Guillermo Alcalá Gamero. All rights reserved.
//

import DGCharts
import Surge
import UIKit

class ChartViewController: UIViewController {
	// MARK: - Outlets
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBOutlet weak var lineChartView: LineChartView!
	@IBOutlet weak var actionButton: UIButton!
	
	// MARK: - Variables
	var numberOfDataPoints: Int = .zero
	var accelerometerData: [MotionDataPointModel] = []
	var gyroscopeData: [MotionDataPointModel] = []
	var velocityData: [MotionDataPointModel] = []
	var gravityData: [MotionDataPointModel] = []
	
	var accelerometerVerticalData: [TimedDataPoint] = []	// Computed values based on the accelerometer and gravity.
	var velocityVerticalData: [TimedDataPoint] = []			// Computed values based on the accelerometer and gravity.
	var velocityVerticalFixedData: [TimedDataPoint] = []	// Fixed vertical velocity to avoid drifts.
	var repetitions: [MotionRepetition] = []				// Computed repetitions based on velocities
	
	// MARK: - Chart datasets
	var accelerometerXDataset: LineChartDataSet = LineChartDataSet()        	// Chart dataset of accelerometer values in the X-Axis.
	var accelerometerYDataset: LineChartDataSet = LineChartDataSet()        	// Chart dataset of accelerometer values in the Y-Axis.
	var accelerometerZDataset: LineChartDataSet = LineChartDataSet()        	// Chart dataset of accelerometer values in the Z-Axis.
	var accelerometerVerticalDataset: LineChartDataSet = LineChartDataSet()   	// Chart dataset of accelerometer values based on the acceleration and gravity.
	
	var velocityXDataset: LineChartDataSet = LineChartDataSet()					// Chart dataset of velocity values in the X-Axis.
	var velocityYDataset: LineChartDataSet = LineChartDataSet()					// Chart dataset of velocity values in the Y-Axis.
	var velocityZDataset: LineChartDataSet = LineChartDataSet()					// Chart dataset of velocity values in the Z-Axis.
	var velocityVerticalDataset: LineChartDataSet = LineChartDataSet()			// Chart dataset of velocity values based on the accelerometer and gravity.
	
	var gravityXDataset: LineChartDataSet = LineChartDataSet()					// Chart dataset of the gravity values in the X-Axis.
	var gravityYDataset: LineChartDataSet = LineChartDataSet()					// Chart dataset of the gravity values in the Y-Axis.
	var gravityZDataset: LineChartDataSet = LineChartDataSet()					// Chart dataset of the gravity values in the Z-Axis.
	
	// MARK: - Constants
	let gravity = 9.81
	let velocityThreshold: Double = 0.1
	
	// MARK: - Services
	let motionQueue: OperationQueue = OperationQueue(maxConcurrentOperationCount: 1)
	let motionService: DeviceMotionServiceProtocol = CoreMotionService.shared
	
	var updateIntervalOn: TimeInterval { motionService.updateIntervalOn }
	var updateIntervalOff: TimeInterval { motionService.updateIntervalOff }
	
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
		segmentedControl.setTitle(MotionCharts.ACCELERATION.title, forSegmentAt: MotionCharts.ACCELERATION.rawValue)
		segmentedControl.setTitle(MotionCharts.VELOCITY.title, forSegmentAt: MotionCharts.VELOCITY.rawValue)
		segmentedControl.setTitle(MotionCharts.GRAVITY.title, forSegmentAt: MotionCharts.GRAVITY.rawValue)
		segmentedControl.selectedSegmentIndex = MotionCharts.VELOCITY.rawValue
	}
	
	func setupCharts() {
		lineChartView.chartDescription.text = MotionCharts(rawValue: segmentedControl.selectedSegmentIndex)?.description
		
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
		let deviceMotionUpdateInterval = willPause ? updateIntervalOff : updateIntervalOn
		motionService.deviceMotionUpdateInterval = deviceMotionUpdateInterval
		
		// Trigger haptic notification
		vibrateDevice()
		
		willPause ? stopRecordData() : startRecordData()
	}
	
	// MARK: - Data recording
	func startRecordData() {
		guard motionService.isDeviceMotionAvailable else { return }
		
		resetData()
		
		motionService.startDeviceMotionUpdates(to: motionQueue) { [weak self] model in
			self?.updateMotionData(model)
			
			let position = self?.numberOfDataPoints ?? .zero
			self?.updateChartIfNeeded(at: position - 1)
			
			self?.reloadChartOnMainThread()
		} failure: { [weak self] error in
			self?.stopRecordData()
		}
	}
	
	func stopRecordData() {
		guard motionService.isDeviceMotionAvailable else { return }
		motionService.stopDeviceMotionUpdates()
		
		processMotionData()
		evaluateRepetitions()
		
		reloadChart()
	}
	
	// MARK: - Data management
	func updateMotionData(_ data: DeviceMotionServiceModel) {
		// https://www.nxp.com/docs/en/application-note/AN3397.pdf
		// https://www.wired.com/story/iphone-accelerometer-physics/
		
		// Retrieve device motion data
		let newTimestamp = data.timestamp
		
		// Convert the G values to Meters per squared seconds.
		let newXAcceleration =  data.userAcceleration.x * gravity
		let newYAcceleration =  data.userAcceleration.y * gravity
		let newZAcceleration =  data.userAcceleration.z * gravity
		
		let newXGravity = data.gravity.x
		let newYGravity = data.gravity.y
		let newZGravity = data.gravity.z
		
		let newXGyro = data.rotationRate.x
		let newYGyro = data.rotationRate.y
		let newZGyro = data.rotationRate.z
		
		// Compute scalar projection of the acceleration vector onto the gravity vector
		let gravityModule = sqrt(pow(newXGravity, 2) + pow(newYGravity, 2) + pow(newZGravity, 2))
		let accelerationVector = [newXAcceleration, newYAcceleration, newZAcceleration]
		let gravityVector = [newXGravity, newYGravity, newZGravity]
		let dotProduct = Surge.dot(gravityVector, accelerationVector)
		let scalarProjection = gravityVector.map { dotProduct / pow(gravityModule, 2) * $0 }
		
		// Instant velocity calculation by integration
		let lastAccelerometerData = accelerometerData.last ?? .zero
		
		let newXVelocity = (lastAccelerometerData.x * updateIntervalOn) + (newXAcceleration - lastAccelerometerData.x) * (updateIntervalOn / 2)
		let newYVelocity = (lastAccelerometerData.y * updateIntervalOn) + (newYAcceleration - lastAccelerometerData.y) * (updateIntervalOn / 2)
		let newZVelocity = (lastAccelerometerData.z * updateIntervalOn) + (newZAcceleration - lastAccelerometerData.z) * (updateIntervalOn / 2)
		
		// Compute vertical acceleration and velocity
		let lastAccelerometerVerticalData = accelerometerVerticalData.last?.value ?? .zero
		
		let dotProductSign = dotProduct.sign == .plus ? 1.0 : -1.0
		let scalarProjectionX = scalarProjection.at(0) ?? .zero
		let scalarProjectionY = scalarProjection.at(1) ?? .zero
		let scalarProjectionZ = scalarProjection.at(2) ?? .zero
		
		let newVerticalAcceleration = dotProductSign * sqrt(pow(scalarProjectionX, 2) + pow(scalarProjectionY, 2) + pow(scalarProjectionZ, 2))
		let newVerticalVelocity =
		(lastAccelerometerVerticalData * updateIntervalOn) + (newVerticalAcceleration - lastAccelerometerVerticalData) * (updateIntervalOn / 2)
		
		// Current velocity by cumulative velocities.
		let lastVelocityData = velocityData.last ?? .zero
		let lastVelocityVerticalData = velocityVerticalData.last?.value ?? .zero
		
		let currentXVelocity = lastVelocityData.x + newXVelocity
		let currentYVelocity = lastVelocityData.y + newYVelocity
		let currentZVelocity = lastVelocityData.z + newZVelocity
		let currentVerticalVelocity = lastVelocityVerticalData + newVerticalVelocity
		
		// Data storage
		let acceleration = MotionDataPointModel(
			timestamp: newTimestamp,
			x: newXAcceleration,
			y: newYAcceleration,
			z: newZAcceleration
		)
		accelerometerData.append(acceleration)
		
		let verticalAcceleration = TimedDataPointModel(
			timestamp: newTimestamp,
			value: newVerticalAcceleration
		)
		accelerometerVerticalData.append(verticalAcceleration)
		
		let velocity = MotionDataPointModel(
			timestamp: newTimestamp,
			x: currentXVelocity,
			y: currentYVelocity,
			z: currentZVelocity
		)
		velocityData.append(velocity)
		
		let verticalVelocity = TimedDataPointModel(
			timestamp: newTimestamp,
			value: currentVerticalVelocity
		)
		velocityVerticalData.append(verticalVelocity)
		
		let newGravity = MotionDataPointModel(
			timestamp: newTimestamp,
			x: newXGravity,
			y: newYGravity,
			z: newZGravity
		)
		gravityData.append(newGravity)
		
		let newRotation = MotionDataPointModel(
			timestamp: newTimestamp,
			x: newXGyro,
			y: newYGyro,
			z: newZGyro
		)
		gyroscopeData.append(newRotation)
		
		numberOfDataPoints += 1
	}
	
	func processMotionData() {
		let lastVelocityVerticalData = velocityVerticalData.last?.value ?? .zero
		let slope = lastVelocityVerticalData / Double(velocityVerticalData.count)
		
		// Remove lineally the slope from the vertical acceleration.
		velocityVerticalFixedData = velocityVerticalData.enumerated().map({ index, element in
			let fixedValue = element.value - slope * Double(index)
			let result = TimedDataPointModel(
				timestamp: element.timestamp,
				value: fixedValue
			)
			return result
		})
		
		// Clear and update vertical velocity chart with new data
		resetDataSet(velocityVerticalDataset)
		
		for i in 0..<velocityVerticalFixedData.count where i % 10 == 0 {
			let position = Double(i) / 100
			let element = velocityVerticalFixedData.at(i)
			let value = element?.value ?? .zero
			let entryVerticalVelocity = ChartDataEntry(x: position, y: value)
			velocityVerticalDataset.append(entryVerticalVelocity)
		}
	}
	
	func evaluateRepetitions() {
		let slicedVelocities = velocityVerticalFixedData
			.split(whereSeparator: { abs($0.value) < velocityThreshold })	// Split the sequence when the data crosses the threshold
			.filter({ $0.count > 10 })										// Filter intervals that seems to be too short
		
		// Join split velocities by pairs to assemble a repetition (positive + negative)
		let velocitiesByRepetition: [[any TimedDataPoint]] = stride(from: .zero, to: slicedVelocities.count, by: 2)
			.compactMap { index in
				guard index + 1 < slicedVelocities.count else { return nil }
				let velocitiesSlice = slicedVelocities[index..<index+2]
				let velocities = Array(velocitiesSlice).flatMap { $0 }
				return velocities
			}
		
		let repetitions = velocitiesByRepetition.map({ MotionRepetitionModel(velocities: $0) })
		self.repetitions = repetitions
	}

	
	// MARK: - Chart management
	func resetData() {
		numberOfDataPoints = .zero
		accelerometerData.removeAll()
		gyroscopeData.removeAll()
		velocityData.removeAll()
		gravityData.removeAll()
		
		accelerometerVerticalData.removeAll()
		velocityVerticalData.removeAll()
		velocityVerticalFixedData.removeAll()
		repetitions.removeAll()
		
		// Clean acceleration chart dataset
		resetDataSet(accelerometerXDataset)
		resetDataSet(accelerometerYDataset)
		resetDataSet(accelerometerZDataset)
		resetDataSet(accelerometerVerticalDataset)
		
		// Clean velocity chart dataset
		resetDataSet(velocityXDataset)
		resetDataSet(velocityYDataset)
		resetDataSet(velocityZDataset)
		resetDataSet(velocityVerticalDataset)
		
		// Clean gravity chart dataset
		resetDataSet(gravityXDataset)
		resetDataSet(gravityYDataset)
		resetDataSet(gravityZDataset)
		
		// Clean chart (LineChartView)
		resetChart(lineChartView)
		
		// Empty data added to the chart
		reloadChart()
	}
	
	func resetDataSet(_ dataSet: LineChartDataSet) {
		// keepingCapacity must be true to keep dataset style.
		dataSet.removeAll(keepingCapacity: true)
	}
	
	func resetChart(_ chart: LineChartView) {
		chart.clear()
	}
	
	func updateChart(at position: Int) {
		let chartPosition = Double(position) * updateIntervalOn
		
		// Acceleration added to Chart
		let entryXAcceleration = ChartDataEntry(x: chartPosition, y: accelerometerData.at(position)?.x ?? .zero)
		let entryYAcceleration = ChartDataEntry(x: chartPosition, y: accelerometerData.at(position)?.y ?? .zero)
		let entryZAcceleration = ChartDataEntry(x: chartPosition, y: accelerometerData.at(position)?.z ?? .zero)
		let entryVerticalAcceleration = ChartDataEntry(x: chartPosition, y: accelerometerVerticalData.at(position)?.value ?? .zero)
		
		accelerometerXDataset.append(entryXAcceleration)
		accelerometerYDataset.append(entryYAcceleration)
		accelerometerZDataset.append(entryZAcceleration)
		accelerometerVerticalDataset.append(entryVerticalAcceleration)
		
		// Velocity added to Chart
		let entryXVelocity = ChartDataEntry(x: chartPosition, y: velocityData.at(position)?.x ?? .zero)
		let entryYVelocity = ChartDataEntry(x: chartPosition, y: velocityData.at(position)?.y ?? .zero)
		let entryZVelocity = ChartDataEntry(x: chartPosition, y: velocityData.at(position)?.z ?? .zero)
		let entryVerticalVelocity = ChartDataEntry(x: chartPosition, y: velocityVerticalData.at(position)?.value ?? .zero)
		
		velocityXDataset.append(entryXVelocity)
		velocityYDataset.append(entryYVelocity)
		velocityZDataset.append(entryZVelocity)
		velocityVerticalDataset.append(entryVerticalVelocity)
		
		// Gravity added to the Chart
		let entryXGravity = ChartDataEntry(x: chartPosition, y: gravityData.at(position)?.x ?? .zero)
		let entryYGravity = ChartDataEntry(x: chartPosition, y: gravityData.at(position)?.y ?? .zero)
		let entryZGravity = ChartDataEntry(x: chartPosition, y: gravityData.at(position)?.z ?? .zero)
		
		gravityXDataset.append(entryXGravity)
		gravityYDataset.append(entryYGravity)
		gravityZDataset.append(entryZGravity)
	}
	
	func updateChartIfNeeded(at position: Int) {
		// Add one of every ten entrances per second. You need to use round(). If not, 201 is casted as 200, thus true.
		guard position % 10 == 0 else { return }
		updateChart(at: position)
	}
	
	func reloadChart() {
		let dataSets: [any ChartDataSetProtocol]
		
		switch segmentedControl.selectedSegmentIndex {
		case MotionCharts.ACCELERATION.rawValue:
			dataSets = [
				accelerometerXDataset,
				accelerometerYDataset,
				accelerometerZDataset,
				accelerometerVerticalDataset
			]
		case MotionCharts.VELOCITY.rawValue:
			dataSets = [
				velocityXDataset,
				velocityYDataset,
				velocityZDataset,
				velocityVerticalDataset
			]
		case MotionCharts.GRAVITY.rawValue:
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
	
	func reloadChartOnMainThread() {
		DispatchQueue.main.async {
			self.reloadChart()
		}
	}
	
	// MARK: - Navigations
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		segue.destination.navigationItem.title = LocalizedKeys.Common.results
		
		let resultsTableViewController = segue.destination as? ResultsTableViewController
		
		resultsTableViewController?.repetitions = repetitions
	}
}
