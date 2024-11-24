//
//  ChartPresenterTests.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 23/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest

@testable import Speed_Gauge

final class ChartPresenterTests: XCTestCase {
	
	var presenter: ChartPresenter?
	var viewMock: ChartViewControllerMock?
	var motionServiceMock: DeviceMotionServiceInputMock?
	var repetitionsServiceMock: RepetitionsServiceInputMock?
	var routerMock: RouterMock?
	
	override func setUpWithError() throws {
		super.setUp()
		
		let viewMock = ChartViewControllerMock()
		let motionServiceMock = DeviceMotionServiceInputMock()
		let repetitionsServiceMock = RepetitionsServiceInputMock()
		let routerMock = RouterMock()
		
		let presenter = ChartPresenter(view: viewMock, assemblyDTO: nil)
		presenter.motionService = motionServiceMock
		presenter.repetitionsService = repetitionsServiceMock
		presenter.router = routerMock
		
		self.viewMock = viewMock
		self.motionServiceMock = motionServiceMock
		self.repetitionsServiceMock = repetitionsServiceMock
		self.routerMock = routerMock
		
		self.presenter = presenter
	}
	
	override func tearDownWithError() throws {
		super.tearDown()
		
		self.viewMock = nil
		self.presenter = nil
	}
	
	func test_setupCharts() {
		presenter?.setupCharts()
		
		let result = viewMock?.setupChartDataSetCalled
		XCTAssert(result.isTrue)
	}
	
	func test_resetCharts() {
		presenter?.resetCharts()
		
		let result = viewMock?.resetChartDataSetCalled
		XCTAssert(result.isTrue)
	}
	
	func test_loadCharts() {
		presenter?.loadCharts()
		
		let result = viewMock?.reloadChartCalled
		XCTAssert(result.isTrue)
	}
	
	func test_loadChartAtPosition_0() {
		presenter?.loadChart(at: 0)
		
		runOnMainThreadIfNecessary { [weak self] in
			let result = self?.viewMock?.reloadChartDataSetsCalled
			XCTAssert(result.isTrue)
		}
	}
	
	func test_loadChartAtPosition_1() {
		presenter?.loadChart(at: 1)
		
		runOnMainThreadIfNecessary { [weak self] in
			let result = self?.viewMock?.reloadChartDataSetsCalled
			XCTAssert(result.isTrue)
		}
	}
	
	func test_loadChartAtPosition_2() {
		presenter?.loadChart(at: 2)
		
		runOnMainThreadIfNecessary { [weak self] in
			let result = self?.viewMock?.reloadChartDataSetsCalled
			XCTAssert(result.isTrue)
		}
	}
	
	func test_goToResults() {
		presenter?.goToResults()
		
		let result = routerMock?.pushCalled
		XCTAssert(result.isTrue)
	}
	
	func test_startMeasures() {
		presenter?.startMeasures()
		
		var result = viewMock?.resetChartDataSetCalled
		XCTAssert(result.isTrue)
		
		result = viewMock?.reloadChartCalled
		XCTAssert(result.isTrue)
		
		result = motionServiceMock?.startDeviceMotionUpdatesCalled
		XCTAssert(result.isTrue)
	}
	
	func test_stopMeasures() {
		presenter?.stopMeasures()
		
		var result = motionServiceMock?.stopDeviceMotionUpdatesCalled
		XCTAssert(result.isTrue)
		
		result = motionServiceMock?.processMotionDataCalled
		XCTAssert(result.isTrue)
		
		result = repetitionsServiceMock?.evaluateRepetitionsCalled
		XCTAssert(result.isTrue)
	}
	
	func test_deviceMotionDataUpdated_shouldIncludesDataEntry() {
		let motionData: MotionDataModel = .zero
		presenter?.numberOfDataEntries = -1
		
		presenter?.deviceMotionDataUpdated(motionData)
		
		runOnMainThreadIfNecessary { [weak self] in
			let result = self?.viewMock?.reloadChartCalled
			XCTAssert(result.isTrue)
		}
	}
	
	func test_deviceMotionDataUpdated_shouldNotIncludesDataEntry() {
		let motionData: MotionDataModel = .zero
		presenter?.numberOfDataEntries = 0
		
		presenter?.deviceMotionDataUpdated(motionData)
		
		runOnMainThreadIfNecessary { [weak self] in
			let result = self?.viewMock?.reloadChartCalled
			XCTAssert(result.isFalse)
		}
	}
	
	func test_deviceMotionDataUpdated_batchOfData() {
		let motionData: MotionDataModel = .zero
		
		presenter?.deviceMotionDataUpdated([motionData])
		
		var result = viewMock?.resetChartDataSetCalled
		XCTAssert(result.isTrue)
		
		runOnMainThreadIfNecessary { [weak self] in
			result = self?.viewMock?.reloadChartCalled
			XCTAssert(result.isTrue)
		}
	}
	
	func test_evaluateRepetitions() {
		let repetition: MotionRepetitionModel = .zero
		
		presenter?.evaluateRepetitions([repetition])
		
		let result = viewMock?.updateRepetitionsCalled
		XCTAssert(result.isTrue)
	}
}
