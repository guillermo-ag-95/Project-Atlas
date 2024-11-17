//
//  RepetitionCellModel.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 17/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

struct RepetitionCellModel {
	let title: String
	let subtitle: String
	
	init(title: String, subtitle: String) {
		self.title = title
		self.subtitle = subtitle
	}
	
	init(model: MotionRepetition, at index: Int) {
		let repetition = LocalizedKeys.Repetition.title
		let number = index + 1
		let title = String(format: "%@ %d", repetition, number)
		self.title = title
		
		let metersPerSecond = LocalizedKeys.Repetition.metersPerSecond
		let seconds = LocalizedKeys.Repetition.seconds
		
		let maxVelocityTitle = LocalizedKeys.Velocity.max
		let maxVelocityValue = model.maxVelocity
		let maxVelocity = String(format: "%@: %.2f %@", maxVelocityTitle, maxVelocityValue, metersPerSecond)
		
		let meanVelocityTitle = LocalizedKeys.Velocity.mean
		let meanVelocityValue = model.meanVelocity
		let meanVelocity = String(format: "%@: %.2f %@", meanVelocityTitle, meanVelocityValue, metersPerSecond)
		
		let durationTitle = LocalizedKeys.Velocity.duration
		let durationValue = model.duration
		let duration = String(format: "%@: %.2f %@", durationTitle, durationValue, seconds)
		
		let subtitle = [maxVelocity, meanVelocity, duration].joined(separator: "\n")
		self.subtitle = subtitle
	}
}
