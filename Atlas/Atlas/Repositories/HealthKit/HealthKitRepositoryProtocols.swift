//
//  HealthKitRepositoryProtocols.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 9/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import HealthKit

protocol HealthKitRepositoryInputProtocol: AnyObject {
	var output: HealthKitRepositoryOutputProtocol? { get set }
	
	var isAvailable: Bool { get }
	
	func startSession(
		type: HealthKitRepositoryActivityType,
		location: HealthKitRepositoryLocationType
	)
	
	func prepareSession(
		type: HealthKitRepositoryActivityType,
		location: HealthKitRepositoryLocationType
	)
	
	func pauseSession()
	func resumeSession()
	func endSession()
	
	func startActivity()
	func stopActivity()
}

protocol HealthKitRepositoryOutputProtocol: AnyObject {
	func didChangeState(
		session: HealthKitRepositorySession,
		from state: HealthKitRepositoryState,
		to state: HealthKitRepositoryState,
		date: Date
	)
	
	func didFailWithError(
		session: HealthKitRepositorySession,
		error: any Error
	)
}

extension HealthKitRepositoryOutputProtocol {
	func didChangeState(
		session: HealthKitRepositorySession,
		from: HealthKitRepositoryState,
		to: HealthKitRepositoryState,
		date: Date
	) { }
	
	func didFailWithError(
		session: HealthKitRepositorySession,
		error: any Error
	) { }
}
