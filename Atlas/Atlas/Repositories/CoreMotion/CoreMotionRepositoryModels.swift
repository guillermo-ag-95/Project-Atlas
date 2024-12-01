//
//  CoreMotionRepositoryModels.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 13/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion

// MARK: - Accelerometer repository models
typealias AccelerometerRepositoryModel = CMAccelerometerData
typealias AccelerometerRepositorySuccessHandler = ((AccelerometerRepositoryModel) -> Void)
typealias AccelerometerRepositoryFailureHandler = ((any Error) -> Void)
typealias AccelerometerRepositoryAsyncResult = Result<AccelerometerRepositoryModel, Error>

// MARK: - Gyroscope repository models
typealias GyroscopeRepositoryModel = CMGyroData
typealias GyroscopeRepositorySuccessHandler = ((GyroscopeRepositoryModel) -> Void)
typealias GyroscopeRepositoryFailureHandler = ((any Error) -> Void)
typealias GyroscopeRepositoryAsyncResult = Result<GyroscopeRepositoryModel, Error>

// MARK: - DeviceMotion repository models
typealias DeviceMotionRepositoryModel = CMDeviceMotion
typealias DeviceMotionRepositorySuccessHandler = ((DeviceMotionRepositoryModel) -> Void)
typealias DeviceMotionRepositoryFailureHandler = ((any Error) -> Void)
typealias DeviceMotionRepositoryAsyncResult = Result<DeviceMotionRepositoryModel, Error>
