//
//  Bool+Extension.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 8/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

extension Bool {
	func encode() -> Data? {
		let result = try? JSONEncoder().encode(self)
		return result
	}
}
