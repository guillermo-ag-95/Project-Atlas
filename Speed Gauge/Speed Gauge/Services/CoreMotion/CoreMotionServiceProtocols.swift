//
//  CoreMotionServiceProtocols.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 20/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion

// MARK: - CoreMotion protocol
protocol CoreMotionServiceProtocol: AnyObject {
	var updateIntervalOn: TimeInterval { get }
	var updateIntervalOff: TimeInterval { get }
}

// MARK: - Accelerometer protocols
protocol AccelerometerServiceProtocol: CoreMotionServiceProtocol {
	var isAccelerometerAvailable: Bool { get }
	var accelerometerData: CMAccelerometerData? { get }
	
	var accelerometerUpdateInterval: TimeInterval { get set }
	
	func startAccelerometerUpdates()
	func stopAccelerometerUpdates()
}

protocol AccelerometerServiceSyncProtocol: AccelerometerServiceProtocol {
	func startAccelerometerUpdates(
		to operation: OperationQueue,
		success: @escaping AccelerometerServiceSuccessHandler,
		failure: @escaping AccelerometerServiceFailureHandler
	)
}

protocol AccelerometerServiceAsyncProtocol: AccelerometerServiceProtocol {
	func startacccelerometerUpdates(
		to operation: OperationQueue
	) async -> AccelerometerServiceAsyncResult
}

// MARK: - Gyroscope protocols
protocol GyroscopeServiceProtocol: CoreMotionServiceProtocol {
	var isGyroAvailable: Bool { get }
	var gyroData: CMGyroData? { get }
	
	var gyroUpdateInterval: TimeInterval { get set }
	
	func startGyroUpdates()
	func stopGyroUpdates()
}

protocol GyroscopeServiceSyncProtocol: GyroscopeServiceProtocol {
	func startGyroUpdates(
		to operation: OperationQueue,
		success: @escaping GyroscopeServiceSuccessHandler,
		failure: @escaping GyroscopeServiceFailureHandler
	)
}

protocol GyroscopeServiceAsyncProtocol: GyroscopeServiceProtocol {
	func startGyroUpdates(
		to operation: OperationQueue
	) async -> GyroscopeServiceAsyncResult
}

// MARK: - DeviceMotion protocols
protocol DeviceMotionServiceProtocol: CoreMotionServiceProtocol {
	var isDeviceMotionAvailable: Bool { get }
	var deviceMotion: CMDeviceMotion? { get }
	
	var deviceMotionUpdateInterval: TimeInterval { get set }
	
	func startDeviceMotionUpdates()
	func stopDeviceMotionUpdates()
}

protocol DeviceMotionServiceSyncProtocol: DeviceMotionServiceProtocol {
	func startDeviceMotionUpdates(
		to operation: OperationQueue,
		success: @escaping DeviceMotionServiceSuccessHandler,
		failure: @escaping DeviceMotionServiceFailureHandler
	)
}

protocol DeviceMotionServiceAsyncProtocol: DeviceMotionServiceProtocol {
	func startDeviceMotionUpdates(
		to operation: OperationQueue
	) async -> DeviceMotionServiceAsyncResult
}
