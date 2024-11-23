//
//  ChartPresenter.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 20/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import DGCharts
import Foundation

protocol ChartPresenterProtocol: AnyObject {
	func setupCharts()
	func resetCharts()
	func loadCharts()
	func loadChart(at position: Int)
	
	func startMeasures()
	func stopMeasures()
	
	func goToResults()
}

class ChartPresenter {
	weak var view: ChartViewControllerProtocol?
	var motionService: DeviceMotionServiceInputProtocol?
	var repetitionsService: RepetitionsServiceInputProtocol?
	
	var assemblyDTO: ChartAssemblyDTO?
	
	init(view: ChartViewControllerProtocol, assemblyDTO: ChartAssemblyDTO?) {
		self.assemblyDTO = assemblyDTO
		self.view = view
	}
	
	// MARK: - Presentation data
	internal var numberOfDataEntries: Int = -1
	internal let reduceNumberOfDataEntriesBy: Int = 10 // .zero
	
	private var accelerationXDataset: ChartDataSet = LineChartDataSet()
	private var accelerationYDataset: ChartDataSet = LineChartDataSet()
	private var accelerationZDataset: ChartDataSet = LineChartDataSet()
	
	private var velocityXDataset: ChartDataSet = LineChartDataSet()
	private var velocityYDataset: ChartDataSet = LineChartDataSet()
	private var velocityZDataset: ChartDataSet = LineChartDataSet()
	
	private var gravityXDataset: ChartDataSet = LineChartDataSet()
	private var gravityYDataset: ChartDataSet = LineChartDataSet()
	private var gravityZDataset: ChartDataSet = LineChartDataSet()
	
	private var verticalAccelerationDataset: ChartDataSet = LineChartDataSet()
	private var verticalVelocityDataset: ChartDataSet = LineChartDataSet()
	
	private var repetitions: [any MotionRepetition] = []
}

// MARK: - ChartPresenterProtocol
extension ChartPresenter: ChartPresenterProtocol {
	// Do nothing
}

// MARK: - Chart management
extension ChartPresenter {
	func setupCharts() {
		[accelerationXDataset, velocityXDataset, gravityXDataset].forEach {
			view?.setupChartDataSet($0, label: LocalizedKeys.Common.xAxis, color: .appRed, pointSize: 1)
		}
		
		[accelerationYDataset, velocityYDataset, gravityYDataset].forEach {
			view?.setupChartDataSet($0, label: LocalizedKeys.Common.yAxis, color: .appGreen, pointSize: 1)
		}
																		  
		[accelerationZDataset, velocityZDataset, gravityZDataset].forEach {
			view?.setupChartDataSet($0, label: LocalizedKeys.Common.zAxis, color: .appBlue, pointSize: 1)
		}
		
		view?.setupChartDataSet(
			verticalAccelerationDataset,
			label: LocalizedKeys.Acceleration.vertical,
			color: .appBlack,
			pointSize: 1
		)
		
		view?.setupChartDataSet(
			verticalVelocityDataset,
			label: LocalizedKeys.Velocity.vertical,
			color: .appBlack,
			pointSize: 1
		)
	}
	
	func resetCharts() {
		numberOfDataEntries = -1
		
		[accelerationXDataset, accelerationYDataset, accelerationZDataset].forEach {
			view?.resetChartDataSet($0)
		}
		
		[velocityXDataset, velocityYDataset, velocityZDataset].forEach {
			view?.resetChartDataSet($0)
		}
		
		[gravityXDataset, gravityYDataset, gravityZDataset].forEach {
			view?.resetChartDataSet($0)
		}
		
		[verticalAccelerationDataset, verticalVelocityDataset].forEach {
			view?.resetChartDataSet($0)
		}
	}
	
	func loadCharts() {
		view?.reloadChart()
	}
	
	func loadChart(at position: Int) {
		let dataSets = manageDataSet(at: position)
		
		runOnMainThreadIfNecessary { [weak self] in
			self?.view?.reloadChartDataSets(dataSets)
		}
	}
	
	private func manageDataSet(at position: Int) -> [ChartDataSet] {
		let dataSets: [ChartDataSet]
		
		switch position {
		case MotionCharts.ACCELERATION.rawValue:
			dataSets = [
				accelerationXDataset,
				accelerationYDataset,
				accelerationZDataset,
				verticalAccelerationDataset
			]
		case MotionCharts.VELOCITY.rawValue:
			dataSets = [
				velocityXDataset,
				velocityYDataset,
				velocityZDataset,
				verticalVelocityDataset
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
		
		return dataSets
	}
	
	func goToResults() {
		let dto = ResultsAssemblyDTO(repetitions: repetitions)
		Router.push(.results(dto: dto))
	}
}

// MARK: - Measures management
extension ChartPresenter {
	func startMeasures() {
		resetCharts()
		loadCharts()
		
		motionService?.startDeviceMotionUpdates()
	}
	
	func stopMeasures() {
		motionService?.stopDeviceMotionUpdates()
		motionService?.processMotionData()
		
		let motionData = motionService?.motionData ?? []
		repetitionsService?.evaluateRepetitions(from: motionData)
	}
}

extension ChartPresenter: DeviceMotionServiceOutputProtocol {
	func deviceMotionDataUpdated(_ data: any MotionData) {		
		numberOfDataEntries += 1
		
		guard shouldIncludesDataEntry(at: numberOfDataEntries) else { return }
		
		let position = Double(numberOfDataEntries)
		
		let accelerationXEntry = ChartDataEntry(x: position, y: data.acceleration.x)
		let accelerationYEntry = ChartDataEntry(x: position, y: data.acceleration.y)
		let accelerationZEntry = ChartDataEntry(x: position, y: data.acceleration.z)
		
		let velocityXEntry = ChartDataEntry(x: position, y: data.velocity.x)
		let velocityYEntry = ChartDataEntry(x: position, y: data.velocity.y)
		let velocityZEntry = ChartDataEntry(x: position, y: data.velocity.z)
		
		let gravityXEntry = ChartDataEntry(x: position, y: data.gravity.x)
		let gravityYEntry = ChartDataEntry(x: position, y: data.gravity.y)
		let gravityZEntry = ChartDataEntry(x: position, y: data.gravity.z)
		
		let verticalAccelerationEntry = ChartDataEntry(x: position, y: data.verticalAcceleration.value)
		let verticalVelocityEntry = ChartDataEntry(x: position, y: data.verticalVelocity.value)
		
		accelerationXDataset.append(accelerationXEntry)
		accelerationYDataset.append(accelerationYEntry)
		accelerationZDataset.append(accelerationZEntry)
		
		velocityXDataset.append(velocityXEntry)
		velocityYDataset.append(velocityYEntry)
		velocityZDataset.append(velocityZEntry)
		
		gravityXDataset.append(gravityXEntry)
		gravityYDataset.append(gravityYEntry)
		gravityZDataset.append(gravityZEntry)
		
		verticalAccelerationDataset.append(verticalAccelerationEntry)
		verticalVelocityDataset.append(verticalVelocityEntry)
		
		runOnMainThreadIfNecessary { [weak self] in
			self?.view?.reloadChart()
		}
	}
	
	func deviceMotionDataUpdated(_ data: [any MotionData]) {
		// TODO: Adapt function to limit its scope beyond vertical velocities
		// For now, it'll manage only vertical velocities after post-processing
		// In the future, it should be use to handle multiple motion data model at once.
		
		view?.resetChartDataSet(verticalVelocityDataset)
		
		let verticalVelocitiesEntries: [ChartDataEntry] = data.enumerated().map { index, point in
			guard shouldIncludesDataEntry(at: index) else { return nil }
			
			let position = Double(index)
			let entry = ChartDataEntry(x: position, y: point.verticalVelocity.value)
			return entry
		}.compactMap(\.self)
		
		verticalVelocityDataset.append(contentsOf: verticalVelocitiesEntries)
		
		runOnMainThreadIfNecessary { [weak self] in
			self?.view?.reloadChart()
		}
	}
	
	/// Check if the new data entry should be included in the charts.
	/// If the limiting factor is zero, all data entries are included.
	/// - Parameter index: Position of the new data entry in the charts
	/// - Returns: If the data entry should be included in the data set.
	///
	/// Due to performance issues, not every data entry should be included in the chart.
	///
	/// When these issues are resolved, this function won't be necessary.
	private func shouldIncludesDataEntry(at index: Int) -> Bool {
		guard reduceNumberOfDataEntriesBy > .zero else { return true }
		
		let result = index.isMultiple(of: reduceNumberOfDataEntriesBy)
		return result
	}
}

// MARK: - RepetitionsServiceOutputProtocol
extension ChartPresenter: RepetitionsServiceOutputProtocol {
	func evaluateRepetitions(_ repetitions: [any MotionRepetition]) {
		self.repetitions = repetitions
		
		view?.updateRepetitions(repetitions)
	}
}
