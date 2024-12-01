//
//  RepetitionsService.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 20/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

protocol RepetitionsServiceInputProtocol: AnyObject {
	func evaluateRepetitions(from motionData: [MotionData])
}

protocol RepetitionsServiceOutputProtocol: AnyObject {
	func evaluateRepetitions(_ repetitions: [MotionRepetition])
}

class RepetitionsService {
	weak var output: RepetitionsServiceOutputProtocol?
	
	init(output: RepetitionsServiceOutputProtocol) {
		self.output = output
	}
	
	// MARK: - Service data
	private let velocityTheshold: Double = 0.1
}

extension RepetitionsService: RepetitionsServiceInputProtocol {
	func evaluateRepetitions(from motionData: [any MotionData]) {
		let verticalVelocities = motionData.map(\.verticalVelocity)
		
		// Split the sequence when the data crosses the threshold
		let splitVelocities = verticalVelocities.split(whereSeparator: { abs($0.value) < velocityTheshold })
		
		// Filter intervals that seems to be too short
		let filteredSplitVelocities = splitVelocities.filter { $0.count > 10 }
		
		// Join split velocities by pairs to assemble a repetition (positive + nevagtive)
		let velocitiesByRepetition: [[any TimedDataPoint]] = stride(from: .zero, to: filteredSplitVelocities.count, by: 2)
			.compactMap { index in
				guard index + 1 < filteredSplitVelocities.count else { return nil }
				let velocitiesSlice = filteredSplitVelocities[index..<index+2]
				let velocities = Array(velocitiesSlice).flatMap { $0 }
				return velocities
			}
		
		let repetitions = velocitiesByRepetition.map {
			MotionRepetitionModel(velocities: $0)
		}
		
		output?.evaluateRepetitions(repetitions)
	}
}
