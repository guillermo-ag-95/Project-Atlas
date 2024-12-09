//
//  WatchConnectivityService.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 7/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

typealias WatchConnectivityServiceInputProtocol = WatchConnectivityRepositoryInputProtocol
typealias WatchConnectivityServiceOutputProtocol = WatchConnectivityRepositoryOutputProtocol

class WatchConnectivityService {
	weak var output: WatchConnectivityServiceOutputProtocol?
	internal var repository: WatchConnectivityRepositoryInputProtocol?
	
	init(output: WatchConnectivityServiceOutputProtocol) {
		self.output = output
	}
}

extension WatchConnectivityService: WatchConnectivityServiceInputProtocol {
	var isSupported: Bool {
		repository?.isSupported ?? false
	}
	
	var isReachable: Bool {
		repository?.isReachable ?? false
	}
	
	func sendMessage(_ message: WatchConnectivityRepositoryMessageModel, reply: WatchConnectivityRepositoryReplyMessageHandler, error: WatchConnectivityRepositoryErrorMessageHandler) {
		repository?.sendMessage(message, reply: reply, error: error)
	}
	
	func sendData(_ data: WatchConnectivityRepositoryDataModel, reply: WatchConnectivityRepositoryReplyDataHandler, error: WatchConnectivityRepositoryErrorDataHandler) {
		repository?.sendData(data, reply: reply, error: error)
	}
}

extension WatchConnectivityService: WatchConnectivityRepositoryOutputProtocol {
	func didCompleteWith(session: WatchConnectivitySession, status: WatchConnectivityActivationStatus, error: WatchConnectivityActivationError) {
		output?.didCompleteWith(session: session, status: status, error: error)
	}
	
	func didBecomeInactive(session: WatchConnectivitySession) {
		output?.didBecomeInactive(session: session)
	}
	
	func didDeactivate(session: WatchConnectivitySession) {
		output?.didDeactivate(session: session)
	}
	
	func didReceiveMessage(session: WatchConnectivitySession, message: WatchConnectivityRepositoryMessageModel, reply: WatchConnectivityRepositoryReplyMessageHandler) {
		output?.didReceiveMessage(session: session, message: message, reply: reply)
	}
	
	func didReceiveData(session: WatchConnectivitySession, data: WatchConnectivityRepositoryDataModel, reply: WatchConnectivityRepositoryReplyDataHandler) {
		output?.didReceiveData(session: session, data: data, reply: reply)
	}
}
