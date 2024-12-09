//
//  DeviceMotionCodableModel.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 8/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion

struct DeviceMotionCodableModel: Codable {
	let timestamp: TimeInterval
	let userAcceleration: AccelerationData
	let gravity: AccelerationData
	let rotationRate: RotationRateData
	let attitude: AttitudeData
	
	struct AccelerationData: Codable {
		let x: Double
		let y: Double
		let z: Double
	}
	
	struct RotationRateData: Codable {
		let x: Double
		let y: Double
		let z: Double
	}
	
	struct AttitudeData: Codable {
		let roll: Double
		let pitch: Double
		let yaw: Double
		let rotationMatrix: RotationMatrixData
		let quaternion: QuaternionData
	}
	
	struct RotationMatrixData: Codable {
		let m11: Double
		let m12: Double
		let m13: Double
		let m21: Double
		let m22: Double
		let m23: Double
		let m31: Double
		let m32: Double
		let m33: Double
	}
	
	struct QuaternionData: Codable {
		let x: Double
		let y: Double
		let z: Double
		let w: Double
	}
	
	init(_ motion: CMDeviceMotion) {
		let timestamp = motion.timestamp
		
		let userAcceleration = AccelerationData(
			x: motion.userAcceleration.x,
			y: motion.userAcceleration.y,
			z: motion.userAcceleration.z
		)
		
		let gravity = AccelerationData(
			x: motion.gravity.x,
			y: motion.gravity.y,
			z: motion.gravity.z
		)
		
		let rotationRate = RotationRateData(
			x: motion.rotationRate.x,
			y: motion.rotationRate.y,
			z: motion.rotationRate.z
		)
		
		let rotationMatrix = RotationMatrixData(
			m11: motion.attitude.rotationMatrix.m11,
			m12: motion.attitude.rotationMatrix.m12,
			m13: motion.attitude.rotationMatrix.m13,
			m21: motion.attitude.rotationMatrix.m21,
			m22: motion.attitude.rotationMatrix.m22,
			m23: motion.attitude.rotationMatrix.m23,
			m31: motion.attitude.rotationMatrix.m31,
			m32: motion.attitude.rotationMatrix.m32,
			m33: motion.attitude.rotationMatrix.m33
		)
		
		let quaternion = QuaternionData(
			x: motion.attitude.quaternion.x,
			y: motion.attitude.quaternion.y,
			z: motion.attitude.quaternion.z,
			w: motion.attitude.quaternion.w
		)
		
		let attitude = AttitudeData(
			roll: motion.attitude.roll,
			pitch: motion.attitude.pitch,
			yaw: motion.attitude.yaw,
			rotationMatrix: rotationMatrix,
			quaternion: quaternion
		)
		
		self.timestamp = timestamp
		self.userAcceleration = userAcceleration
		self.gravity = gravity
		self.rotationRate = rotationRate
		self.attitude = attitude
	}
	
	// MARK: - Codable
	static func encode(motion: CMDeviceMotion) -> Data? {
		let codable = DeviceMotionCodableModel(motion)
		let result = try? JSONEncoder().encode(codable)
		return result
	}
	
	static func decode(data: Data) -> DeviceMotionCodableModel? {
		let codable = try? JSONDecoder().decode(DeviceMotionCodableModel.self, from: data)
		return codable
	}
}
