//
//  ObservableObject+Extension.swift
//  Atlas Companion Watch App
//
//  Created by Guillermo Alcalá Gamero on 7/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import WatchKit

extension ObservableObject {
	func vibrateDevice(_ type: WKHapticType) {
		WKInterfaceDevice.current().play(type)
	}
}
