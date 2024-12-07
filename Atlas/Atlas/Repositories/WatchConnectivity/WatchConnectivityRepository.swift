//
//  WatchConnectivityRepository.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 7/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import WatchConnectivity

class WatchConnectivityRepository: NSObject {
	weak var output: WatchConnectivityRepositoryOutputProtocol?
	
	private let session: WCSession = .default
	
	init(output: WatchConnectivityRepositoryOutputProtocol) {
		super.init()
		
		guard WCSession.isSupported() else { return }
		
		self.output = output
		session.delegate = self
		session.activate()
	}
}

extension WatchConnectivityRepository: WatchConnectivityRepositoryInputProtocol {
	var isSupported: Bool {
		WCSession.isSupported()
	}
	
	var isReachable: Bool {
		session.isReachable
	}
	
	func sendMessage(
		_ message: WatchConnectivityRepositoryMessageModel,
		reply: WatchConnectivityRepositoryReplyMessageHandler,
		error: WatchConnectivityRepositoryErrorMessageHandler
	) {
		guard session.isReachable else { return }
		session.sendMessage(message, replyHandler: reply, errorHandler: error)
	}
	
	func sendData(
		_ data: WatchConnectivityRepositoryDataModel,
		reply: WatchConnectivityRepositoryReplyDataHandler,
		error: WatchConnectivityRepositoryErrorDataHandler
	) {
		guard session.isReachable else { return }
		session.sendMessageData(data, replyHandler: reply, errorHandler: error)
	}
}

extension WatchConnectivityRepository: WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
		output?.didCompleteWith(status: activationState, error: error)
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		output?.didBecomeInactive()
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		output?.didDeactivate()
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		output?.didReceiveMessage(message, reply: nil)
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		output?.didReceiveMessage(message, reply: replyHandler)
	}
	
	func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
		output?.didReceiveData(messageData, reply: nil)
	}
	
	func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
		output?.didReceiveData(messageData, reply: replyHandler)
	}
}
