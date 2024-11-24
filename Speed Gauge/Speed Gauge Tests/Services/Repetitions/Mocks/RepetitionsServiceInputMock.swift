//
//  RepetitionsServiceInputMock.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 24/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

@testable import Speed_Gauge

class RepetitionsServiceInputMock: RepetitionsServiceInputProtocol {
	var evaluateRepetitionsCalled = false
	
	func evaluateRepetitions(from motionData: [any MotionData]) {
		evaluateRepetitionsCalled = true
	}
}
