//
//  String+Extension.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 12/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

extension String {
	static var empty: String {
		return .init()
	}
	
	var localized: String {
		let result = NSLocalizedString(self, comment: .empty)
		return result
	}
}
