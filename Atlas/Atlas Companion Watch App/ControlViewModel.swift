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
	private var queue: OperationQueue = .init(maxConcurrentOperationCount: 1, qos: .userInteractive)
	private var coreMotionRepository: DeviceMotionRepositorySyncProtocol?
	private var watchConnectivityRepository: WatchConnectivityRepositoryInputProtocol?
	
	@Published var isPaused: Bool = true {
		didSet {
			guard isPaused != oldValue else { return }
			
			if isPaused {
				stopMotionUpdates()
				vibrateDevice(.stop)
				notifyPhone()
			} else {
				vibrateDevice(.start)
				notifyPhone()
				startMotionUpdates()
			}
		}
	}
	
	init() {
		coreMotionRepository = CoreMotionRepository.shared
		watchConnectivityRepository = WatchConnectivityRepository(output: self)
	}
	
	private func updateState(_ state: Bool) {
		self.isPaused = state
	}
	
	private func notifyPhone() {
		guard let state = try? NSKeyedArchiver.archivedData(withRootObject: isPaused, requiringSecureCoding: true) else { return }
		watchConnectivityRepository?.sendData(state, reply: nil, error: nil)
	}
	
	private func startMotionUpdates() {
		coreMotionRepository?.startDeviceMotionUpdates(to: queue, success: { [weak self] model in
			self?.sendMotionUpdates(model)
		}, failure: { [weak self] error  in
			self?.stopMotionUpdates()
		})
	}
	
	private func stopMotionUpdates() {
		coreMotionRepository?.stopDeviceMotionUpdates()
	}
	
	private func sendMotionUpdates(_ model: DeviceMotionRepositoryModel) {
		guard let updates = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: true) else { return }
		watchConnectivityRepository?.sendData(updates, reply: nil, error: nil)
	}
}

extension ControlViewModel: WatchConnectivityRepositoryOutputProtocol {
	func didReceiveData(session: WatchConnectivitySession, data: WatchConnectivityRepositoryDataModel, reply: WatchConnectivityRepositoryReplyDataHandler) {
		let unarchivedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
		
		switch unarchivedData {
		case let state as Bool:
			runOnMainThreadIfNecessary { [weak self] in
				self?.updateState(state)
			}
		default:
			break
		}
	}
}
