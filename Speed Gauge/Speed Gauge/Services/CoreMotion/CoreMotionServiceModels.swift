//
//  CoreMotionServiceModels.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 13/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import CoreMotion

// MARK: - AccelerometerService models
typealias AccelerometerServiceModel = CMAccelerometerData
typealias AccelerometerServiceSuccessHandler = ((AccelerometerServiceModel) -> Void)
typealias AccelerometerServiceFailureHandler = ((any Error) -> Void)
typealias AccelerometerServiceAsyncResult = Result<AccelerometerServiceModel, Error>

// MARK: - GyroscopeService models
typealias GyroscopeServiceModel = CMGyroData
typealias GyroscopeServiceSuccessHandler = ((GyroscopeServiceModel) -> Void)
typealias GyroscopeServiceFailureHandler = ((any Error) -> Void)
typealias GyroscopeServiceAsyncResult = Result<GyroscopeServiceModel, Error>

// MARK: - DeviceMotionService models
typealias DeviceMotionServiceModel = CMDeviceMotion
typealias DeviceMotionServiceSuccessHandler = ((DeviceMotionServiceModel) -> Void)
typealias DeviceMotionServiceFailureHandler = ((any Error) -> Void)
typealias DeviceMotionServiceAsyncResult = Result<DeviceMotionServiceModel, Error>
