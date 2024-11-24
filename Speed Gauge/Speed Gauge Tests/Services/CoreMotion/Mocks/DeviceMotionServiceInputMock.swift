//
//  DeviceMotionServiceInputMock.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 24/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

@testable import Speed_Gauge

class DeviceMotionServiceInputMock: DeviceMotionServiceInputProtocol {
	var startDeviceMotionUpdatesCalled: Bool = false
	var stopDeviceMotionUpdatesCalled: Bool = false
	var processMotionDataCalled: Bool = false
	
	var motionData: [MotionDataModel] = []
	
	func startDeviceMotionUpdates() {
		startDeviceMotionUpdatesCalled = true
	}
	
	func stopDeviceMotionUpdates() {
		stopDeviceMotionUpdatesCalled = true
	}
	
	func processMotionData() {
		processMotionDataCalled = true
	}
}
