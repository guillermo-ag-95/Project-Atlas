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

// MARK: - DeviceMotion protocol
protocol DeviceMotionServiceProtocol: AccelerometerServiceProtocol {
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
	internal var manager = CMMotionManager()
}

// MARK: - DeviceMotionService
class DeviceMotionService: CoreMotionService {
	
}

extension DeviceMotionService: AccelerometerServiceProtocol {
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

extension DeviceMotionService: DeviceMotionServiceProtocol {
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
