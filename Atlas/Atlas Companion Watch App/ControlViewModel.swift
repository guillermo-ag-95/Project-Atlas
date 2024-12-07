//
//  ControlViewModel.swift
//  Atlas Companion Watch App
//
//  Created by Guillermo Alcalá Gamero on 1/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import SwiftUI
import WatchConnectivity

class ControlViewModel: NSObject, ObservableObject {
	private var watchConnectivitySession: WCSession? = WCSession.default
	
	@Published var isPaused: Bool = true {
		didSet {
			guard isPaused != oldValue else { return }
			vibrateDevice(isPaused ? .stop : .start)
			notifyPhone()
		}
	}
	
	override init() {
		super.init()
		
		guard WCSession.isSupported() else { return }
		watchConnectivitySession?.delegate = self
		watchConnectivitySession?.activate()
	}
	
	private func notifyPhone() {
		guard let watchConnectivitySession, watchConnectivitySession.isReachable else { return }
		
		let message: [String: Any] = ["state": isPaused]
		
		watchConnectivitySession.sendMessage(message) { reply in
			print("G - \(Self.self) - \(#function) - reply: \(reply)")
		} errorHandler: { error in
			print("G - \(Self.self) - \(#function) - error: \(error.localizedDescription)")
		}
	}
}

extension ControlViewModel: WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
		print("G - \(Self.self) - \(#function) - session: \(session) - activationState: \(activationState) - error: \(error?.localizedDescription ?? "")")
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		print("G - \(Self.self) - \(#function) - session: \(session) - message: \(message)")
		
		DispatchQueue.main.async { [weak self] in
			self?.updateState(message: message)
		}
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		print("G - \(Self.self) - \(#function) - session: \(session) - message: \(message) - replyHandler: \(String(describing: replyHandler))")
		
		DispatchQueue.main.async { [weak self] in
			self?.updateState(message: message)
		}
	}
	
	private func updateState(message: [String: Any]) {
		guard let isPaused = message["state"] as? Bool else { return }
		self.isPaused = isPaused
	}
}
