//
//  UIResponder+Extension.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 7/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

extension UIResponder {
	/// Trigger haptic notification
	func vibrateDevice() {
		UIDevice.vibrateDevice()
	}
}
