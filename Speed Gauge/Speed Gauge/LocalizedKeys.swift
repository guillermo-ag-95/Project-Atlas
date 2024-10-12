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
		static var graphs = "graphs".localized
		static var results = "results".localized
		static var xAxis = "x_axis".localized
		static var yAxis = "y_axis".localized
		static var zAxis = "z_axis".localized
	}
	
	// MARK: - Acceleration
	struct Acceleration {
		static var title = "acceleration".localized
		static var byAxis = "acceleration_by_axis".localized
		static var vertical = "vertical_acceleration".localized
	}
	
	// MARK: - Velocity
	struct Velocity {
		static var title = "velocity".localized
		static var byAxis = "velocity_by_axis".localized
		static var vertical = "vertical_velocity".localized
		static var max = "max_velocity".localized
		static var mean = "mean_velocity".localized
	}
	
	// MARK: - Gravity
	struct Gravity {
		static var title = "gravity".localized
		static var byAxis = "gravity_by_axis".localized
	}
	
	// MARK: - Repetition
	struct Repetition {
		static var title = "repetition".localized
		static var metersPerSecond = "meters_per_second_hint".localized
	}
}
