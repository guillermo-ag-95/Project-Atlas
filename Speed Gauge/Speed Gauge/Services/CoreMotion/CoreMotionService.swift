//
//  CoreMotionService.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 13/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion

// MARK: - CoreMotion service
class CoreMotionService: CoreMotionServiceProtocol {
	let updateIntervalOn: TimeInterval = 0.01 // 100 Hz (1/100 s)
	let updateIntervalOff: TimeInterval = 0.1 // 10 Hz (1/10 s)
	
	private var manager = CMMotionManager()
	
	private init() { }
	
	static let shared: CoreMotionService = .init()
}

// MARK: - Accelerometer protocols extensions
extension CoreMotionService: AccelerometerServiceProtocol {
	var isAccelerometerAvailable: Bool { manager.isAccelerometerAvailable }
	var accelerometerData: CMAccelerometerData? { manager.accelerometerData }
	
	var accelerometerUpdateInterval: TimeInterval {
		get { manager.accelerometerUpdateInterval }
		set { manager.accelerometerUpdateInterval = newValue }
	}
	
	func startAccelerometerUpdates() {
		manager.startAccelerometerUpdates()
	}
	
	func stopAccelerometerUpdates() {
		manager.stopAccelerometerUpdates()
	}
}

extension CoreMotionService: AccelerometerServiceSyncProtocol {
	func startAccelerometerUpdates(
		to operation: OperationQueue,
		success: @escaping AccelerometerServiceSuccessHandler,
		failure: @escaping AccelerometerServiceFailureHandler
	) {
		manager.startAccelerometerUpdates(to: operation) { data, error in
			if let error = error {
				failure(error)
			} else if let data = data {
				success(data)
			} else {
				let error = NSError()
				failure(error)
			}
		}
	}
}

extension CoreMotionService: AccelerometerServiceAsyncProtocol {
	func startacccelerometerUpdates(
		to operation: OperationQueue
	) async -> AccelerometerServiceAsyncResult {
		let result = await withCheckedContinuation { continuation in
			self.startAccelerometerUpdates(to: operation) { data in
				continuation.resume(returning: Result.success(data))
			} failure: { error in
				continuation.resume(returning: Result.failure(error))
			}
		}
		
		return result
	}
}

// MARK: - Gyroscope protocols extensions
extension CoreMotionService: GyroscopeServiceProtocol {
	var isGyroAvailable: Bool { manager.isGyroAvailable }
	var gyroData: CMGyroData? { manager.gyroData }
	
	var gyroUpdateInterval: TimeInterval {
		get { manager.gyroUpdateInterval }
		set { manager.gyroUpdateInterval = newValue }
	}
	
	func startGyroUpdates() {
		manager.startGyroUpdates()
	}
	
	func stopGyroUpdates() {
		manager.stopGyroUpdates()
	}
}

extension CoreMotionService: GyroscopeServiceSyncProtocol {
	func startGyroUpdates(
		to operation: OperationQueue,
		success: @escaping GyroscopeServiceSuccessHandler,
		failure: @escaping GyroscopeServiceFailureHandler
	) {
		manager.startGyroUpdates(to: operation) { data, error in
			if let error = error {
				failure(error)
			} else if let data = data {
				success(data)
			} else {
				let error = NSError()
				failure(error)
			}
		}
	}
}

extension CoreMotionService: GyroscopeServiceAsyncProtocol {
	func startGyroUpdates(
		to operation: OperationQueue
	) async -> GyroscopeServiceAsyncResult {
		let result = await withCheckedContinuation { continuation in
			self.startGyroUpdates(to: operation) { data in
				continuation.resume(returning: Result.success(data))
			} failure: { error in
				continuation.resume(returning: Result.failure(error))
			}
		}
		
		return result
	}
}

// MARK: - DeviceMotion protocols extensions
extension CoreMotionService: DeviceMotionServiceProtocol {
	var isDeviceMotionAvailable: Bool { manager.isDeviceMotionAvailable }
	var deviceMotion: CMDeviceMotion? { manager.deviceMotion }
	
	var deviceMotionUpdateInterval: TimeInterval {
		get { manager.deviceMotionUpdateInterval }
		set { manager.deviceMotionUpdateInterval = newValue }
	}
	
	func startDeviceMotionUpdates() {
		manager.startDeviceMotionUpdates()
	}
	
	func stopDeviceMotionUpdates() {
		manager.stopDeviceMotionUpdates()
	}
}

extension CoreMotionService: DeviceMotionServiceSyncProtocol {
	func startDeviceMotionUpdates(
		to operation: OperationQueue,
		success: @escaping DeviceMotionServiceSuccessHandler,
		failure: @escaping DeviceMotionServiceFailureHandler
	) {
		manager.startDeviceMotionUpdates(to: operation) { data, error in
			if let error = error {
				failure(error)
			} else if let data = data {
				success(data)
			} else {
				let error = NSError()
				failure(error)
			}
		}
	}
}

extension CoreMotionService: DeviceMotionServiceAsyncProtocol {
	func startDeviceMotionUpdates(
		to operation: OperationQueue
	) async -> DeviceMotionServiceAsyncResult {
		let result = await withCheckedContinuation { continuation in
			self.startDeviceMotionUpdates(to: operation) { data in
				continuation.resume(returning: Result.success(data))
			} failure: { error in
				continuation.resume(returning: Result.failure(error))
			}
		}
		
		return result
	}
}
