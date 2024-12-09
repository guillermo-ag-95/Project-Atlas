//
//  CMAttitudeModel.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 8/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion

class CMAttitudeModel: CMAttitude {
	// MARK: - Properties
	private let _roll: Double
	private let _pitch: Double
	private let _yaw: Double
	private let _rotationMatrix: CMRotationMatrix
	private let _quaternion: CMQuaternion
	
	// MARK: - Initializers
	init(
		roll: Double,
		pitch: Double,
		yaw: Double,
		rotationMatrix: CMRotationMatrix,
		quaternion: CMQuaternion
	) {
		self._roll = roll
		self._pitch = pitch
		self._yaw = yaw
		self._rotationMatrix = rotationMatrix
		self._quaternion = quaternion
		
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Variables
	override var roll: Double {
		return _roll
	}
	
	override var pitch: Double {
		return _pitch
	}
	
	override var yaw: Double {
		return _yaw
	}
	
	override var rotationMatrix: CMRotationMatrix {
		return _rotationMatrix
	}
	
	override var quaternion: CMQuaternion {
		return _quaternion
	}
}
