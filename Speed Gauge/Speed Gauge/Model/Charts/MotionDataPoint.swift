//
//  MotionDataPoint.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 14/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

protocol TimedDataPoint {
	var timestamp: TimeInterval { get }
	var value: Double { get }
}

struct TimedDataPointModel: TimedDataPoint {
	let timestamp: TimeInterval
	let value: Double
	
	static var zero: Self {
		Self(timestamp: Date.now.timeIntervalSinceReferenceDate, value: .zero)
	}
}

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
