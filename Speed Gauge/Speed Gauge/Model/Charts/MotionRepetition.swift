//
//  MotionRepetition.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 19/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

protocol MotionRepetition {
	var beginning: TimeInterval { get }
	var ending: TimeInterval { get }
	var duration: TimeInterval { get }
	var maxVelocity: Double { get }
	var meanVelocity: Double { get }
}

struct MotionRepetitionModel: MotionRepetition {
	private let velocities: [TimedDataPoint]
	
	// MARK: - Timestamps
	let beginning: TimeInterval
	let ending: TimeInterval
	let duration: TimeInterval
	
	// MARK: - Max and mean velocities
	let maxVelocity: Double
	let meanVelocity: Double
	
	// MARK: - Initializer
	init(velocities: [TimedDataPoint]) {
		self.velocities = velocities
		
		let beginning = velocities.first?.timestamp ?? .zero
		let ending = velocities.last?.timestamp ?? .zero
		let duration = ending - beginning
		
		self.beginning = beginning
		self.ending = ending
		self.duration = duration
		
		let maxVelocity = velocities.map(\.value).max() ?? .zero
		self.maxVelocity = maxVelocity
		
		let positiveVelocities = velocities.filter(\.value.isPositive)
		let meanVelocity = positiveVelocities.map(\.value).reduce(0, +) / Double(positiveVelocities.count)
		self.meanVelocity = meanVelocity
	}
}
