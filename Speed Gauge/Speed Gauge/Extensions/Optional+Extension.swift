//
//  Optional+Extension.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 19/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

extension Optional {
	public var isNull: Bool {
		return self == nil
	}
	
	public var isNotNull: Bool {
		return !isNull
	}
}
