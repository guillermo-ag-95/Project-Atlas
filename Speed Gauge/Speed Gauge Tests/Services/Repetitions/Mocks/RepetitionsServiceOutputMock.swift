//
//  RepetitionsServiceOutputMock.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 24/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

@testable import Speed_Gauge

class RepetitionsServiceOutputMock: RepetitionsServiceOutputProtocol {
	var evaluateRepetitionsCalled: Bool = false
	
	func evaluateRepetitions(_ repetitions: [any MotionRepetition]) {
		evaluateRepetitionsCalled = true
	}
}
