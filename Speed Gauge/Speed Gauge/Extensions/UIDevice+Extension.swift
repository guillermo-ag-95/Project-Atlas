//
//  UIDevice+Extension.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 13/10/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import AVFoundation
import UIKit

extension UIDevice {
	func vibrate() {
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
	}
	
	/// SIMToolkitGeneralBeep.caf --> 1052
	func playSound(_ sound: SystemSoundID = 1052) {
		AudioServicesPlaySystemSound(sound)
	}
}
