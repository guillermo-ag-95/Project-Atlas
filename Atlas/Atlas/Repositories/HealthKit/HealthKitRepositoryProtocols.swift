//
//  HealthKitRepositoryProtocols.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 9/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import HealthKit

protocol HealthKitRepositoryProtocol: AnyObject {
	func startSession(type: HealthKitRepositoryActivityType, location: HealthKitRepositoryLocationType)
	func pauseSession()
	func resumeSession()
	func endSession()
	
	func startActivity()
	func stopActivity()
}
