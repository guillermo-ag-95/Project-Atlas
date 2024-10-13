//
//  UIResponder+Extension.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 13/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

extension UIResponder {
	func vibrateDevice() {
		UIDevice.current.vibrate()
	}
}
