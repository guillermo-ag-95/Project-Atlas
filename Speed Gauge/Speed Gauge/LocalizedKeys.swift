//
//  LocalizedKeys.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 12/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

struct LocalizedKeys {
	// MARK: - Common
	struct Common {
		static let graphs = "graphs".localized
		static let results = "results".localized
		static let xAxis = "x_axis".localized
		static let yAxis = "y_axis".localized
		static let zAxis = "z_axis".localized
	}
	
	// MARK: - Acceleration
	struct Acceleration {
		static let title = "acceleration".localized
		static let byAxis = "acceleration_by_axis".localized
		static let vertical = "vertical_acceleration".localized
	}
	
	// MARK: - Velocity
	struct Velocity {
		static let title = "velocity".localized
		static let byAxis = "velocity_by_axis".localized
		static let vertical = "vertical_velocity".localized
		static let max = "max_velocity".localized
		static let mean = "mean_velocity".localized
		static let duration = "duration".localized
	}
	
	// MARK: - Gravity
	struct Gravity {
		static let title = "gravity".localized
		static let byAxis = "gravity_by_axis".localized
	}
	
	// MARK: - Repetition
	struct Repetition {
		static let title = "repetition".localized
		static let metersPerSecond = "meters_per_second_hint".localized
		static let seconds = "seconds_hint".localized
	}
}
