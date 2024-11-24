//
//  DeviceMotionService.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 24/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest

@testable import Speed_Gauge

final class DeviceMotionServiceTests: XCTestCase {
	var service: DeviceMotionService?
	
	// MARK: - Connections
	var outputMock: DeviceMotionServiceOutputMock?
	var repositoryMock: DeviceMotionRepositorySyncMock?
	
	// MARK: - Repositories
	
	override func setUpWithError() throws {
		super.setUp()
		
		let outputMock = DeviceMotionServiceOutputMock()
		let repositoryMock = DeviceMotionRepositorySyncMock()
		
		let service = DeviceMotionService(output: outputMock)
		service.repository = repositoryMock
		
		self.outputMock = outputMock
		self.repositoryMock = repositoryMock
		self.service = service
	}

	override func tearDownWithError() throws {
		super.tearDown()
		
		self.outputMock = nil
		self.service = nil
	}
	
	func test_startDeviceMotionUpdates_isDeviceMotionNotAvailable() {
		repositoryMock?.isDeviceMotionAvailable = false
		
		service?.startDeviceMotionUpdates()
		
		let result = outputMock?.deviceMotionDataUpdatedCalled
		XCTAssert(result.isFalse)
	}
	
	func test_startDeviceMotionUpdates_willFail() {
		repositoryMock?.isDeviceMotionAvailable = true
		repositoryMock?.willSucceed = false
		
		service?.startDeviceMotionUpdates()
		
		var result = outputMock?.deviceMotionDataUpdatedCalled
		XCTAssert(result.isFalse)
		
		result = repositoryMock?.stopDeviceMotionUpdatesCalled
		XCTAssert(result.isTrue)
	}
	
	func test_startDeviceMotionUpdates_willSucceed() throws {
		repositoryMock?.isDeviceMotionAvailable = true
		repositoryMock?.willSucceed = true
		
		service?.startDeviceMotionUpdates()
		
		let result = outputMock?.deviceMotionDataUpdatedCalled
		XCTAssert(result.isTrue)
	}
	
	func test_processMotionData() {
		service?.processMotionData()
		
		let result = outputMock?.deviceMotionDataUpdatedCalled
		XCTAssert(result.isTrue)
	}
}
