//
//  Array+Extension.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 13/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

extension Array {
	func at(_ index: Int) -> Array.Element? {
		let result = indices.contains(index) ? self[index] : nil
		return result
	}
}
