//
//  CoreMotionRepository.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 13/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion

// MARK: - CoreMotion repository
class CoreMotionRepository: CoreMotionRepositoryProtocol {
	let gravity: Double = 9.80665				// Standard gravity
	let updateIntervalOn: TimeInterval = 0.01	// 100 Hz (1/100 s)
	let updateIntervalOff: TimeInterval = 0.1	// 10 Hz (1/10 s)
	
	private var manager = CMMotionManager()
	
	private init() { }
	
	static let shared: CoreMotionRepository = .init()
}

// MARK: - Accelerometer protocols extensions
extension CoreMotionRepository: AccelerometerRepositoryProtocol {
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

extension CoreMotionRepository: AccelerometerRepositorySyncProtocol {
	func startAccelerometerUpdates(
		to operation: OperationQueue,
		success: @escaping AccelerometerRepositorySuccessHandler,
		failure: @escaping AccelerometerRepositoryFailureHandler
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

extension CoreMotionRepository: AccelerometerRepositoryAsyncProtocol {
	func startacccelerometerUpdates(
		to operation: OperationQueue
	) async -> AccelerometerRepositoryAsyncResult {
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
extension CoreMotionRepository: GyroscopeRepositoryProtocol {
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

extension CoreMotionRepository: GyroscopeRepositorySyncProtocol {
	func startGyroUpdates(
		to operation: OperationQueue,
		success: @escaping GyroscopeRepositorySuccessHandler,
		failure: @escaping GyroscopeRepositoryFailureHandler
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

extension CoreMotionRepository: GyroscopeRepositoryAsyncProtocol {
	func startGyroUpdates(
		to operation: OperationQueue
	) async -> GyroscopeRepositoryAsyncResult {
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
extension CoreMotionRepository: DeviceMotionRepositoryProtocol {
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

extension CoreMotionRepository: DeviceMotionRepositorySyncProtocol {
	func startDeviceMotionUpdates(
		to operation: OperationQueue,
		success: @escaping DeviceMotionRepositorySuccessHandler,
		failure: @escaping DeviceMotionRepositoryFailureHandler
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

extension CoreMotionRepository: DeviceMotionRepositoryAsyncProtocol {
	func startDeviceMotionUpdates(
		to operation: OperationQueue
	) async -> DeviceMotionRepositoryAsyncResult {
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
