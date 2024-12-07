//
//  ControlViewModel.swift
//  Atlas Companion Watch App
//
//  Created by Guillermo Alcalá Gamero on 1/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import SwiftUI
import WatchConnectivity

class ControlViewModel: ObservableObject {
	private var repository: WatchConnectivityRepositoryInputProtocol?
	
	@Published var isPaused: Bool = true {
		didSet {
			guard isPaused != oldValue else { return }
			vibrateDevice(isPaused ? .stop : .start)
			notifyPhone()
		}
	}
	
	init() {
		repository = WatchConnectivityRepository(output: self)
	}
	
	private func updateState(_ state: Bool) {
		self.isPaused = state
	}
	
	private func notifyPhone() {
		let message: [String: Any] = ["state": isPaused]
		repository?.sendMessage(message, reply: nil, error: nil)
	}
}

extension ControlViewModel: WatchConnectivityRepositoryOutputProtocol {
	func didReceiveMessage(_ message: WatchConnectivityRepositoryMessageModel, reply: WatchConnectivityRepositoryReplyMessageHandler) {
		if let state = message["state"] as? Bool {
			runOnMainThreadIfNecessary { [weak self] in
				self?.updateState(state)
			}
		}
	}
}
