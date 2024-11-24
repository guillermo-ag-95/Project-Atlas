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
	
	// MARK: - Repositories
	
	override func setUpWithError() throws {
		super.setUp()
		
		let outputMock = DeviceMotionServiceOutputMock()
		let service = DeviceMotionService(output: outputMock)
		
		self.outputMock = outputMock
		self.service = service
	}

	override func tearDownWithError() throws {
		super.tearDown()
		
		self.outputMock = nil
		self.service = nil
	}
	
	func test_example() {
		
	}
}
