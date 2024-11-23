//
//  DeviceMotionServiceOutputMock.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 23/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

@testable import Speed_Gauge

class DeviceMotionServiceOutputMock: DeviceMotionServiceOutputProtocol {
	var deviceMotionDataUpdatedCalled = false
	
	func deviceMotionDataUpdated(_ data: any MotionData) {
		deviceMotionDataUpdatedCalled = true
	}
	
	func deviceMotionDataUpdated(_ data: [any MotionData]) {
		deviceMotionDataUpdatedCalled = true
	}
}
