//
//  Double+Extension.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 19/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

extension Double {
	var isPositive: Bool {
		let result = self > .zero
		return result
	}
	
	var isNegative: Bool {
		let result = self < .zero
		return result
	}
	
	var isZero: Bool {
		let result = self == .zero
		return result
	}
}
