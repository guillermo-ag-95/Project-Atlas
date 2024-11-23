//
//  DeviceMotionServiceInputMock.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 23/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

@testable import Speed_Gauge

class DeviceMotionServiceInputMock: DeviceMotionServiceInputProtocol {
	var startDeviceMotionUpdatesCalled = false
	var stopDeviceMotionUpdatesCalled = false
	var processMotionDataCalled = false
	
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
