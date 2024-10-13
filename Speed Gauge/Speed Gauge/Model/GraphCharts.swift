//
//  GraphCharts.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 13/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

enum GraphCharts: Int {
	case ACCELERATION
	case VELOCITY
	case GRAVITY
	
	var title: String {
		let result: String
		
		switch self {
		case .ACCELERATION: result = LocalizedKeys.Acceleration.title
		case .VELOCITY: result = LocalizedKeys.Velocity.title
		case .GRAVITY: result = LocalizedKeys.Gravity.title
		}
		
		return result
	}
	
	var description: String {
		let result: String
		
		switch self {
		case .ACCELERATION: result = LocalizedKeys.Acceleration.byAxis
		case .VELOCITY: result = LocalizedKeys.Velocity.byAxis
		case .GRAVITY: result = LocalizedKeys.Gravity.byAxis
		}
		
		return result
	}
}

