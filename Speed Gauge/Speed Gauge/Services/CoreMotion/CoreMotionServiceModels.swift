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

// MARK: - GyroscopeService models
typealias GyroscopeServiceModel = CMGyroData
typealias GyroscopeServiceSuccessHandler = ((GyroscopeServiceModel) -> Void)
typealias GyroscopeServiceFailureHandler = ((any Error) -> Void)

// MARK: - DeviceMotionService models
typealias DeviceMotionServiceModel = CMDeviceMotion
typealias DeviceMotionServiceSuccessHandler = ((DeviceMotionServiceModel) -> Void)
typealias DeviceMotionServiceFailureHandler = ((any Error) -> Void)
