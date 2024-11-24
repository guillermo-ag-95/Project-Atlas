//
//  RepetitionsService.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 24/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest

@testable import Speed_Gauge

final class RepetitionsServiceTests: XCTestCase {
	var service: RepetitionsService?
	
	// MARK: - Connections
	var outputMock: RepetitionsServiceOutputMock?
	
	// MARK: - Repositories
	
	override func setUpWithError() throws {
		super.setUp()
		
		let outputMock = RepetitionsServiceOutputMock()
		let service = RepetitionsService(output: outputMock)
		
		self.outputMock = outputMock
		self.service = service
	}

	override func tearDownWithError() throws {
		super.tearDown()
		
		self.outputMock = nil
		self.service = nil
	}
	
	func test_evaluateRepetitions() {
		let repetitions: [any MotionData] = []
		
		service?.evaluateRepetitions(from: repetitions)
		
		let result = outputMock?.evaluateRepetitionsCalled
		XCTAssert(result.isTrue)
	}
}
