//
//  UIDevice+Extension.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 7/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import AudioToolbox
import UIKit

extension UIDevice {
	static func vibrateDevice() {
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
	}
	
	static func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
		let generator = UIImpactFeedbackGenerator(style: style)
		generator.impactOccurred()
	}
}
