//
//  CoreMotionRepositoryProtocols.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 20/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion

// MARK: - CoreMotion protocol
protocol CoreMotionRepositoryProtocol: AnyObject {
	var gravity: Double { get }
	var updateIntervalOn: TimeInterval { get }
	var updateIntervalOff: TimeInterval { get }
}

// MARK: - Accelerometer protocols
protocol AccelerometerRepositoryProtocol: CoreMotionRepositoryProtocol {
	var isAccelerometerAvailable: Bool { get }
	var accelerometerData: CMAccelerometerData? { get }
	
	var accelerometerUpdateInterval: TimeInterval { get set }
	
	func startAccelerometerUpdates()
	func stopAccelerometerUpdates()
}

protocol AccelerometerRepositorySyncProtocol: AccelerometerRepositoryProtocol {
	func startAccelerometerUpdates(
		to operation: OperationQueue,
		success: @escaping AccelerometerRepositorySuccessHandler,
		failure: @escaping AccelerometerRepositoryFailureHandler
	)
}

protocol AccelerometerRepositoryAsyncProtocol: AccelerometerRepositoryProtocol {
	func startacccelerometerUpdates(
		to operation: OperationQueue
	) async -> AccelerometerRepositoryAsyncResult
}

// MARK: - Gyroscope protocols
protocol GyroscopeRepositoryProtocol: CoreMotionRepositoryProtocol {
	var isGyroAvailable: Bool { get }
	var gyroData: CMGyroData? { get }
	
	var gyroUpdateInterval: TimeInterval { get set }
	
	func startGyroUpdates()
	func stopGyroUpdates()
}

protocol GyroscopeRepositorySyncProtocol: GyroscopeRepositoryProtocol {
	func startGyroUpdates(
		to operation: OperationQueue,
		success: @escaping GyroscopeRepositorySuccessHandler,
		failure: @escaping GyroscopeRepositoryFailureHandler
	)
}

protocol GyroscopeRepositoryAsyncProtocol: GyroscopeRepositoryProtocol {
	func startGyroUpdates(
		to operation: OperationQueue
	) async -> GyroscopeRepositoryAsyncResult
}

// MARK: - DeviceMotion protocols
protocol DeviceMotionRepositoryProtocol: CoreMotionRepositoryProtocol {
	var isDeviceMotionAvailable: Bool { get }
	var deviceMotion: CMDeviceMotion? { get }
	
	var deviceMotionUpdateInterval: TimeInterval { get set }
	
	func startDeviceMotionUpdates()
	func stopDeviceMotionUpdates()
}

protocol DeviceMotionRepositorySyncProtocol: DeviceMotionRepositoryProtocol {
	func startDeviceMotionUpdates(
		to operation: OperationQueue,
		success: @escaping DeviceMotionRepositorySuccessHandler,
		failure: @escaping DeviceMotionRepositoryFailureHandler
	)
}

protocol DeviceMotionRepositoryAsyncProtocol: DeviceMotionRepositoryProtocol {
	func startDeviceMotionUpdates(
		to operation: OperationQueue
	) async -> DeviceMotionRepositoryAsyncResult
}
