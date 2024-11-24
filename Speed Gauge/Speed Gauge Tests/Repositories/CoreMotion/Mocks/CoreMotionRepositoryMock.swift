//
//  CoreMotionRepositoryMock.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 24/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion

@testable import Speed_Gauge

class CoreMotionRepositoryMock: CoreMotionRepositoryProtocol {
	var gravity: Double = 9.81
	var updateIntervalOn: TimeInterval = 0.01
	var updateIntervalOff: TimeInterval = 0.1
} 

class AccelerometerRepositoryMock: CoreMotionRepositoryMock, AccelerometerRepositoryProtocol {
	var startAccelerometerUpdatesCalled: Bool = false
	var stopAccelerometerUpdatesCalled: Bool = false
	
	var isAccelerometerAvailable: Bool = true
	var accelerometerData: CMAccelerometerData?
	
	lazy var accelerometerUpdateInterval: TimeInterval = self.updateIntervalOn
	
	func startAccelerometerUpdates() {
		startAccelerometerUpdatesCalled = true
	}
	
	func stopAccelerometerUpdates() {
		stopAccelerometerUpdatesCalled = true
	}
}

class AccelerometerRepositorySyncMock: AccelerometerRepositoryMock, AccelerometerRepositorySyncProtocol {
	var willSucceed: Bool = false
	
	var startAccelerometerUpdatesDidSucceed: Bool = false
	var startAccelerometerUpdatesDidFail: Bool = false
	
	func startAccelerometerUpdates(
		to operation: OperationQueue,
		success: @escaping AccelerometerRepositorySuccessHandler,
		failure: @escaping AccelerometerRepositoryFailureHandler
	) {
		startAccelerometerUpdatesCalled = true
		
		if willSucceed {
			startAccelerometerUpdatesDidSucceed = true
			
			let model = AccelerometerRepositoryMockModel.zero
			success(model)
		} else {
			startAccelerometerUpdatesDidFail = true
			
			let error = NSError.init()
			failure(error)
		}
	}
}

class GyroscopeRepositoryMock: CoreMotionRepositoryMock, GyroscopeRepositoryProtocol {
	var startGyroUpdatesCalled: Bool = false
	var stopGyroUpdatesCalled: Bool = false
	
	var isGyroAvailable: Bool = true
	var gyroData: CMGyroData?
	
	lazy var gyroUpdateInterval: TimeInterval = self.updateIntervalOn
	
	func startGyroUpdates() {
		startGyroUpdatesCalled = true
	}
	
	func stopGyroUpdates() {
		stopGyroUpdatesCalled = true
	}
}

class GyroscopeRepositorySyncMock: GyroscopeRepositoryMock, GyroscopeRepositorySyncProtocol {
	var willSucceed: Bool = false
	
	var startGyroUpdatesDidSucceed: Bool = false
	var startGyroUpdatesDidFail: Bool = false
	
	func startGyroUpdates(
		to operation: OperationQueue,
		success: @escaping GyroscopeRepositorySuccessHandler,
		failure: @escaping GyroscopeRepositoryFailureHandler
	) {
		startGyroUpdatesCalled = true
		
		if willSucceed {
			startGyroUpdatesDidSucceed = true
			
			let model = GyroscopeRepositoryMockModel.zero
			success(model)
		} else {
			startGyroUpdatesDidFail = true
			
			let error = NSError.init()
			failure(error)
		}
	}
}

class DeviceMotionRepositoryMock: CoreMotionRepositoryMock, DeviceMotionRepositoryProtocol {
	var startDeviceMotionUpdatesCalled: Bool = false
	var stopDeviceMotionUpdatesCalled: Bool = false
	
	var isDeviceMotionAvailable: Bool = true
	var deviceMotion: CMDeviceMotion?
	
	lazy var deviceMotionUpdateInterval: TimeInterval = self.updateIntervalOn
	
	func startDeviceMotionUpdates() {
		startDeviceMotionUpdatesCalled = true
	}
	
	func stopDeviceMotionUpdates() {
		stopDeviceMotionUpdatesCalled = true
	}
}

class DeviceMotionRepositorySyncMock: DeviceMotionRepositoryMock, DeviceMotionRepositorySyncProtocol {
	var willSucceed: Bool = false
	
	var startDeviceMotionUpdatesDidSucceed: Bool = false
	var startDeviceMotionUpdatesDidFail: Bool = false
	
	func startDeviceMotionUpdates(
		to operation: OperationQueue,
		success: @escaping DeviceMotionRepositorySuccessHandler,
		failure: @escaping DeviceMotionRepositoryFailureHandler
	) {
		startDeviceMotionUpdatesCalled = true
		
		if willSucceed {
			startDeviceMotionUpdatesDidSucceed = true
			
			let model = DeviceMotionRepositoryMockModel.zero
			success(model)
		} else {
			stopDeviceMotionUpdatesCalled = true
			
			let error = NSError.init()
			failure(error)
		}
	}
}
