//
//  HealthKitRepository.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 9/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import HealthKit

class HealthKitRepository {
	private let store: HKHealthStore
	private var session: HKWorkoutSession?
	
	private init() {
		self.store = HKHealthStore()
	}
	
	static let shared: HealthKitRepository = .init()
}

extension HealthKitRepository: HealthKitRepositoryProtocol {
	func startSession(type: HealthKitRepositoryActivityType, location: HealthKitRepositoryLocationType) {
		guard HKHealthStore.isHealthDataAvailable() else { return }
		
		if let session, session.state == .paused {
			resumeSession()
		} else {
			prepareSession(type: type, location: location)
		}
	}
	
	private func prepareSession(type: HealthKitRepositoryActivityType, location: HealthKitRepositoryLocationType) {
		guard HKHealthStore.isHealthDataAvailable() else { return }
		
		let configuration = HKWorkoutConfiguration()
		configuration.activityType = type
		configuration.locationType = location
		
		let session = try? HKWorkoutSession(healthStore: store, configuration: configuration)
		session?.prepare()
		
		self.session = session
	}
	
	func pauseSession() {
		guard HKHealthStore.isHealthDataAvailable() else { return }
		
		self.session?.pause()
	}
	
	func resumeSession() {
		guard HKHealthStore.isHealthDataAvailable() else { return }
		
		self.session?.resume()
	}
	
	func endSession() {
		guard HKHealthStore.isHealthDataAvailable() else { return }
		
		self.session?.end()
	}
	
	// MARK: - Activities	
	func startActivity() {
		guard HKHealthStore.isHealthDataAvailable() else { return }
		
		self.session?.startActivity(with: .now)
	}
	
	func stopActivity() {
		guard HKHealthStore.isHealthDataAvailable() else { return }
		
		self.session?.stopActivity(with: .now)
	}
}
