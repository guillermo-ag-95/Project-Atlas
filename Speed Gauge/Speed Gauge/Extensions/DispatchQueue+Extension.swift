//
//  DispatchQueue+Extension.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 10/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

func runOnMainThread(_ block: @escaping () -> Void) {
	DispatchQueue.main.async(execute: block)
}

func runOnMainThreadIfNecessary(_ block: @escaping () -> Void) {
	if Thread.isMainThread {
		block()
	} else {
		runOnMainThread(block)
	}
}

func runOnMainThreadAfterDelay(_ delay: TimeInterval, _ block: @escaping () -> Void) {
	DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
}

func runOnMainThreadAfterDelayIfNecessary(_ delay: TimeInterval, _ block: @escaping () -> Void) {
	if Thread.isMainThread {
		block()
	} else {
		runOnMainThreadAfterDelay(delay, block)
	}
}
