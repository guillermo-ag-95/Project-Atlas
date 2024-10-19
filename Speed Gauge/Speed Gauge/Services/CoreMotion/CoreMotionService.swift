//
//  CoreMotionService.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 13/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion

// MARK: - CoreMotion protocol
protocol CoreMotionServiceProtocol: AnyObject {
	var updateIntervalOn: TimeInterval { get }
	var updateIntervalOff: TimeInterval { get }
}

// MARK: - Accelerometer protocol
protocol AccelerometerServiceProtocol: CoreMotionServiceProtocol {
	var isAccelerometerAvailable: Bool { get }
	var accelerometerData: CMAccelerometerData? { get }
	
	var accelerometerUpdateInterval: TimeInterval { get set }
	
	func startAccelerometerUpdates()
	func stopAccelerometerUpdates()
	
	func startAccelerometerUpdates(
		to operation: OperationQueue,
		success: @escaping AccelerometerServiceSuccessHandler,
		failure: @escaping AccelerometerServiceFailureHandler
	)
}

// MARK: - Gyroscope protocol
protocol GyroscopeServiceProtocol: CoreMotionServiceProtocol {
	var isGyroAvailable: Bool { get }
	var gyroData: CMGyroData? { get }
	
	var gyroUpdateInterval: TimeInterval { get set }
	
	func startGyroUpdates()
	func stopGyroUpdates()
	
	func startGyroUpdates(
		to operation: OperationQueue,
		success: @escaping GyroscopeServiceSuccessHandler,
		failure: @escaping GyroscopeServiceFailureHandler
	)
}

// MARK: - DeviceMotion protocol
protocol DeviceMotionServiceProtocol: CoreMotionServiceProtocol {
	var isDeviceMotionAvailable: Bool { get }
	var deviceMotion: CMDeviceMotion? { get }
	
	var deviceMotionUpdateInterval: TimeInterval { get set }
	
	func startDeviceMotionUpdates()
	func stopDeviceMotionUpdates()
	
	func startDeviceMotionUpdates(
		to operation: OperationQueue,
		success: @escaping DeviceMotionServiceSuccessHandler,
		failure: @escaping DeviceMotionServiceFailureHandler
	)
}

// MARK: - CoreMotion service
class CoreMotionService: CoreMotionServiceProtocol {
	let updateIntervalOn: TimeInterval = 0.01 // 100 Hz (1/100 s)
	let updateIntervalOff: TimeInterval = 0.1 // 10 Hz (1/10 s)
	
	private var manager = CMMotionManager()
	
	private init() { }
	
	static let shared: CoreMotionService = .init()
}

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
