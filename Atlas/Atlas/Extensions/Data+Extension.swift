//
//  Data+Extension.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 8/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

extension Data {
	func decode<T: Decodable>() -> T? {
		let result = try? JSONDecoder().decode(T.self, from: self)
		return result
	}
}
