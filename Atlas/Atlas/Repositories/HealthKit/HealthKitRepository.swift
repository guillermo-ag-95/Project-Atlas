//
//  HealthKitRepository.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 9/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import HealthKit

class HealthKitRepository: NSObject {
	weak var output: HealthKitRepositoryOutputProtocol?
	
	private let store = HKHealthStore()
	private var session: HKWorkoutSession?
	
	init(output: HealthKitRepositoryOutputProtocol) {
		super.init()
		
		self.output = output
	}
}

extension HealthKitRepository: HealthKitRepositoryInputProtocol {
	var isAvailable: Bool {
		HKHealthStore.isHealthDataAvailable()
	}
	
	func startSession(type: HealthKitRepositoryActivityType, location: HealthKitRepositoryLocationType) {
		guard isAvailable else { return }
		
		if let session, session.state == .paused {
			resumeSession()
		} else {
			prepareSession(type: type, location: location)
		}
	}
	
	func prepareSession(type: HealthKitRepositoryActivityType, location: HealthKitRepositoryLocationType) {
		guard isAvailable else { return }
		
		let configuration = HKWorkoutConfiguration()
		configuration.activityType = type
		configuration.locationType = location
		
		let session = try? HKWorkoutSession(healthStore: store, configuration: configuration)
		session?.delegate = self
		session?.prepare()
		
		self.session = session
	}
	
	func pauseSession() {
		guard isAvailable else { return }
		
		self.session?.pause()
	}
	
	func resumeSession() {
		guard isAvailable else { return }
		
		self.session?.resume()
	}
	
	func endSession() {
		guard isAvailable else { return }
		
		self.session?.end()
	}
	
	// MARK: - Activities	
	func startActivity() {
		guard isAvailable else { return }
		
		self.session?.startActivity(with: .now)
	}
	
	func stopActivity() {
		guard isAvailable else { return }
		
		self.session?.stopActivity(with: .now)
	}
}

extension HealthKitRepository: HKWorkoutSessionDelegate {
	func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
		output?.didChangeState(
			session: workoutSession,
			from: fromState,
			to: toState,
			date: date
		)
	}
	
	func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: any Error) {
		output?.didFailWithError(
			session: workoutSession,
			error: error
		)
	}
}
