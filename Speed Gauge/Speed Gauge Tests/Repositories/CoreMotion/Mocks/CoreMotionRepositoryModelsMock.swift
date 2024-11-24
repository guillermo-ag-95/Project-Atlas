//
//  CoreMotionRepositoryModelsMock.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 24/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion

@testable import Speed_Gauge

class AccelerometerRepositoryMockModel: AccelerometerRepositoryModel {
	let x: Double
	let y: Double
	let z: Double
	
	override var timestamp: TimeInterval {
		return Date.now.timeIntervalSinceReferenceDate
	}
	
	override var acceleration: CMAcceleration {
		return .init(x: x, y: y, z: z)
	}
	
	init(x: Double, y: Double, z: Double) {
		self.x = x
		self.y = y
		self.z = z
		
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	static var zero: AccelerometerRepositoryMockModel {
		.init(x: .zero, y: .zero, z: .zero)
	}
}

class GyroscopeRepositoryMockModel: GyroscopeRepositoryModel {
	let x: Double
	let y: Double
	let z: Double
	
	override var timestamp: TimeInterval {
		return Date.now.timeIntervalSinceReferenceDate
	}
	
	override var rotationRate: CMRotationRate {
		return .init(x: x, y: y, z: z)
	}
	
	init(x: Double, y: Double, z: Double) {
		self.x = x
		self.y = y
		self.z = z
		
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	static var zero: GyroscopeRepositoryMockModel {
		.init(x: .zero, y: .zero, z: .zero)
	}
}

class DeviceMotionRepositoryMockModel: DeviceMotionRepositoryModel {
	let accelerationForce: AccelerometerRepositoryMockModel
	let gravityForce: AccelerometerRepositoryMockModel
	let rotation: GyroscopeRepositoryMockModel
	
	override var timestamp: TimeInterval {
		return Date.now.timeIntervalSinceReferenceDate
	}
	
	override var userAcceleration: CMAcceleration {
		return .init(x: accelerationForce.x, y: accelerationForce.y, z: accelerationForce.z)
	}
	
	override var gravity: CMAcceleration {
		return .init(x: gravityForce.x, y: gravityForce.y, z: gravityForce.z)
	}
	
	override var rotationRate: CMRotationRate {
		return .init(x: rotation.x, y: rotation.y, z: rotation.z)
	}
	
	init(acceleration: AccelerometerRepositoryMockModel, gravity: AccelerometerRepositoryMockModel, rotation: GyroscopeRepositoryMockModel) {
		self.accelerationForce = acceleration
		self.gravityForce = gravity
		self.rotation = rotation
		
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	static var zero: DeviceMotionRepositoryMockModel {
		.init(acceleration: .zero, gravity: .zero, rotation: .zero)
	}
}
