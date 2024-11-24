//
//  DeviceMotionService.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 20/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation
import Surge

protocol DeviceMotionServiceInputProtocol: AnyObject {
	var motionData: [MotionDataModel] { get }
	
	func startDeviceMotionUpdates()
	func stopDeviceMotionUpdates()
	func processMotionData()
}

protocol DeviceMotionServiceOutputProtocol: AnyObject {
	func deviceMotionDataUpdated(_ data: MotionData)
	func deviceMotionDataUpdated(_ data: [MotionData])
}

class DeviceMotionService {
	weak var output: DeviceMotionServiceOutputProtocol?
	internal var queue: OperationQueue = .init(maxConcurrentOperationCount: 1)
	internal var repository: DeviceMotionRepositorySyncProtocol = CoreMotionRepository.shared
	
	init(output: DeviceMotionServiceOutputProtocol) {
		self.output = output
	}
	
	// MARK: - Service data
	internal var motionData: [MotionDataModel] = []
}

extension DeviceMotionService: DeviceMotionServiceInputProtocol {
	func startDeviceMotionUpdates() {
		guard repository.isDeviceMotionAvailable else { return }
		
		resetData()
		
		repository.deviceMotionUpdateInterval = repository.updateIntervalOn
		repository.startDeviceMotionUpdates(to: queue) { [weak self] data in
			self?.updateData(data)
		} failure: { [weak self] error in
			self?.stopDeviceMotionUpdates()
		}
	}
	
	func stopDeviceMotionUpdates() {
		repository.deviceMotionUpdateInterval = repository.updateIntervalOff
		repository.stopDeviceMotionUpdates()
	}
	
	private func resetData() {
		motionData.removeAll()
	}
	
	private func updateData(_ data: DeviceMotionRepositoryModel) {
		// https://www.nxp.com/docs/en/application-note/AN3397.pdf
		// https://www.wired.com/story/iphone-accelerometer-physics/
		
		// Retrieve device motion data
		let newTimestamp = data.timestamp
		
		// Convert the G values to Meters per squared seconds.
		let gravity = repository.gravity
		let newXAcceleration =  data.userAcceleration.x * gravity
		let newYAcceleration =  data.userAcceleration.y * gravity
		let newZAcceleration =  data.userAcceleration.z * gravity
		
		let newXGravity = data.gravity.x
		let newYGravity = data.gravity.y
		let newZGravity = data.gravity.z
		
		let newXGyro = data.rotationRate.x
		let newYGyro = data.rotationRate.y
		let newZGyro = data.rotationRate.z
		
		// Compute scalar projection of the acceleration vector onto the gravity vector
		let gravityModule = sqrt(pow(newXGravity, 2) + pow(newYGravity, 2) + pow(newZGravity, 2))
		let accelerationVector = [newXAcceleration, newYAcceleration, newZAcceleration]
		let gravityVector = [newXGravity, newYGravity, newZGravity]
		let dotProduct = Surge.dot(gravityVector, accelerationVector)
		let scalarProjection = gravityVector.map { dotProduct / pow(gravityModule, 2) * $0 }
		
		// Instant velocity calculation by integration
		let lastMotionData = motionData.last ?? .zero
		let lastAccelerationData = lastMotionData.acceleration
		let updateInterval = repository.deviceMotionUpdateInterval
		
		let newXVelocity = (lastAccelerationData.x * updateInterval) + (newXAcceleration - lastAccelerationData.x) * (updateInterval / 2)
		let newYVelocity = (lastAccelerationData.y * updateInterval) + (newYAcceleration - lastAccelerationData.y) * (updateInterval / 2)
		let newZVelocity = (lastAccelerationData.z * updateInterval) + (newZAcceleration - lastAccelerationData.z) * (updateInterval / 2)
		
		// Compute vertical acceleration and velocity
		let lastAccelerationVerticalData = lastMotionData.verticalAcceleration.value
		
		let dotProductSign = dotProduct.sign == .plus ? 1.0 : -1.0
		let scalarProjectionX = scalarProjection.at(0) ?? .zero
		let scalarProjectionY = scalarProjection.at(1) ?? .zero
		let scalarProjectionZ = scalarProjection.at(2) ?? .zero
		
		let newVerticalAcceleration = dotProductSign * sqrt(pow(scalarProjectionX, 2) + pow(scalarProjectionY, 2) + pow(scalarProjectionZ, 2))
		let newVerticalVelocity =
		(lastAccelerationVerticalData * updateInterval) + (newVerticalAcceleration - lastAccelerationVerticalData) * (updateInterval / 2)
		
		// Current velocity by cumulative velocities.
		let lastVelocityData = lastMotionData.velocity
		let lastVelocityVerticalData = lastMotionData.verticalVelocity.value
		
		let currentXVelocity = lastVelocityData.x + newXVelocity
		let currentYVelocity = lastVelocityData.y + newYVelocity
		let currentZVelocity = lastVelocityData.z + newZVelocity
		let currentVerticalVelocity = lastVelocityVerticalData + newVerticalVelocity
		
		// Data storage
		let acceleration = MotionDataPointModel(
			timestamp: newTimestamp,
			x: newXAcceleration,
			y: newYAcceleration,
			z: newZAcceleration
		)
		
		let velocity = MotionDataPointModel(
			timestamp: newTimestamp,
			x: currentXVelocity,
			y: currentYVelocity,
			z: currentZVelocity
		)
		
		let newGravity = MotionDataPointModel(
			timestamp: newTimestamp,
			x: newXGravity,
			y: newYGravity,
			z: newZGravity
		)
		
		let rotation = MotionDataPointModel(
			timestamp: newTimestamp,
			x: newXGyro,
			y: newYGyro,
			z: newZGyro
		)
		
		let verticalAcceleration = TimedDataPointModel(
			timestamp: newTimestamp,
			value: newVerticalAcceleration
		)
		
		let verticalVelocity = TimedDataPointModel(
			timestamp: newTimestamp,
			value: currentVerticalVelocity
		)
		
		let motion = MotionDataModel(
			timestamp: newTimestamp,
			acceleration: acceleration,
			rotation: rotation,
			velocity: velocity,
			gravity: newGravity,
			verticalAcceleration: verticalAcceleration,
			verticalVelocity: verticalVelocity
		)
		
		motionData.append(motion)
		
		output?.deviceMotionDataUpdated(motion)
	}
	
	func processMotionData() {
		let lastVerticalVelocity = motionData.last?.verticalVelocity.value ?? .zero
		let slope = lastVerticalVelocity / Double(motionData.count)
		
		// Remove lineally the slope from the vertical velocity.
		motionData = motionData.enumerated().map { index, data in
			let originalVerticalVelocity = data.verticalVelocity.value
			let shift = slope * Double(index)
			let fixedVerticalVelocity = originalVerticalVelocity - shift
			
			let result = data.updateVerticalVelocity(fixedVerticalVelocity)
			return result
		}
		
		output?.deviceMotionDataUpdated(motionData)
	}
}
