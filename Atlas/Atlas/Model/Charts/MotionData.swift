//
//  MotionData.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 14/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

// MARK: - MotionData
protocol MotionData {
	var timestamp: TimeInterval { get }
	
	var acceleration: MotionDataPointModel { get }
	var rotation: MotionDataPointModel { get }
	var velocity: MotionDataPointModel { get }
	var gravity: MotionDataPointModel { get }
	
	var verticalAcceleration: TimedDataPointModel { get }
	var verticalVelocity: TimedDataPointModel { get }
	
	static var zero: Self { get }
}

struct MotionDataModel: MotionData {
	let timestamp: TimeInterval
	
	let acceleration: MotionDataPointModel
	let rotation: MotionDataPointModel
	let velocity: MotionDataPointModel
	let gravity: MotionDataPointModel
	
	let verticalAcceleration: TimedDataPointModel
	let verticalVelocity: TimedDataPointModel
	
	static var zero: MotionDataModel {
		.init(
			timestamp: Date.now.timeIntervalSinceReferenceDate,
			acceleration: .zero,
			rotation: .zero,
			velocity: .zero,
			gravity: .zero,
			verticalAcceleration: .zero,
			verticalVelocity: .zero
		)
	}
	
	func updateVerticalVelocity(_ fixedVelocity: Double) -> Self {
		let fixedVerticalVelocity = TimedDataPointModel(
			timestamp: timestamp,
			value: fixedVelocity
		)
		
		let result = Self.init(
			timestamp: timestamp,
			acceleration: acceleration,
			rotation: rotation,
			velocity: velocity,
			gravity: gravity,
			verticalAcceleration: verticalAcceleration,
			verticalVelocity: fixedVerticalVelocity
		)
		
		return result
	}
}

// MARK: - TimedDataPoint
protocol TimedDataPoint {
	var timestamp: TimeInterval { get }
	var value: Double { get }
	
	static var zero: Self { get }
}

struct TimedDataPointModel: TimedDataPoint {
	let timestamp: TimeInterval
	let value: Double
	
	static var zero: Self {
		Self(timestamp: Date.now.timeIntervalSinceReferenceDate, value: .zero)
	}
}

// MARK: - MotionDataPoints
protocol MotionDataPoint {
	var timestamp: TimeInterval { get }
	var x: Double { get }
	var y: Double { get }
	var z: Double { get }
	
	static var zero: Self { get }
}

struct MotionDataPointModel: MotionDataPoint {
	let timestamp: TimeInterval
	let x: Double
	let y: Double
	let z: Double
	
	static var zero: Self {
		Self(timestamp: Date.now.timeIntervalSinceReferenceDate, x: .zero, y: .zero, z: .zero)
	}
}
