//
//  OperationQueue+Extension.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 19/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

extension OperationQueue {
	convenience init(maxConcurrentOperationCount: Int) {
		self.init()
		self.maxConcurrentOperationCount = maxConcurrentOperationCount
	}
}
