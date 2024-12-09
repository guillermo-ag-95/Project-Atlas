//
//  CMDeviceMotionModel.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 8/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion

class CMDeviceMotionModel: CMDeviceMotion {
	// MARK: - Properties
	private let _timestamp: TimeInterval
	private let _userAcceleration: CMAcceleration
	private let _gravity: CMAcceleration
	private let _rotationRate: CMRotationRate
	private let _attitude: CMAttitude
	
	// MARK: - Initializers
	init(
		timestamp: TimeInterval,
		userAcceleration: CMAcceleration,
		gravity: CMAcceleration,
		rotationRate: CMRotationRate,
		attitude: CMAttitude
	) {
		self._timestamp = timestamp
		self._userAcceleration = userAcceleration
		self._gravity = gravity
		self._rotationRate = rotationRate
		self._attitude = attitude
		
		super.init()
	}
	
	convenience init(motion: DeviceMotionCodableModel) {
		let timestamp = motion.timestamp
		
		let userAcceleration = CMAcceleration(
			x: motion.userAcceleration.x,
			y: motion.userAcceleration.y,
			z: motion.userAcceleration.z
		)
		
		let gravity = CMAcceleration(
			x: motion.gravity.x,
			y: motion.gravity.y,
			z: motion.gravity.z
		)
		
		let rotationRate = CMRotationRate(
			x: motion.rotationRate.x,
			y: motion.rotationRate.y,
			z: motion.rotationRate.z
		)
		
		let rotationMatrix = CMRotationMatrix(
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
		
		let quaternion = CMQuaternion(
			x: motion.attitude.quaternion.x,
			y: motion.attitude.quaternion.y,
			z: motion.attitude.quaternion.z,
			w: motion.attitude.quaternion.w
		)
		
		let attitude = CMAttitudeModel(
			roll: motion.attitude.roll,
			pitch: motion.attitude.pitch,
			yaw: motion.attitude.yaw,
			rotationMatrix: rotationMatrix,
			quaternion: quaternion
		)
		
		self.init(
			timestamp: timestamp,
			userAcceleration: userAcceleration,
			gravity: gravity,
			rotationRate: rotationRate,
			attitude: attitude
		)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Variables
	override var timestamp: TimeInterval {
		return _timestamp
	}
	
	override var userAcceleration: CMAcceleration {
		return _userAcceleration
	}
	
	override var gravity: CMAcceleration {
		return _gravity
	}
	
	override var rotationRate: CMRotationRate {
		return _rotationRate
	}
	
	override var attitude: CMAttitude {
		return _attitude
	}
}
