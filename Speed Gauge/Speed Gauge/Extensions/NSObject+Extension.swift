//
//  NSObject+Extension.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 17/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

extension NSObject {
	static var nameOfClass: String {
		return String(describing: Self.self)
	}
}
