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
	
	func transferUserInfo(
		_ info: WatchConnectivityRepositoryUserInfo
	) {
		guard session.isReachable else { return }
		session.transferUserInfo(info)
	}
	
	func transferFile(_ file: WatchConnectivityRepositoryFileURL) {
		guard session.isReachable else { return }
		session.transferFile(file, metadata: nil)
	}
}

extension WatchConnectivityRepository: WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
		output?.didCompleteWith(
			session: session,
			status: activationState,
			error: error
		)
	}
	
	#if os(iOS)
	func sessionDidBecomeInactive(_ session: WCSession) {
		output?.didBecomeInactive(session: session)
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		output?.didDeactivate(session: session)
	}
	#endif
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		output?.didReceiveMessage(
			session: session,
			message: message,
			reply: nil
		)
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		output?.didReceiveMessage(
			session: session,
			message: message,
			reply: replyHandler
		)
	}
	
	func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
		output?.didReceiveData(
			session: session,
			data: messageData,
			reply: nil
		)
	}
	
	func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
		output?.didReceiveData(
			session: session,
			data: messageData,
			reply: nil
		)
	}
	
	func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
		output?.didReceiveUserInfo(
			session: session,
			userInfo: userInfo
		)
	}
	
	func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: (any Error)?) {
		output?.didFinishUserInfoTransfer(
			session: session,
			userInfo: userInfoTransfer,
			error: error
		)
	}
	
	func session(_ session: WCSession, didReceive file: WCSessionFile) {
		output?.didReceiveFile(
			session: session,
			file: file
		)
	}
	
	func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: (any Error)?) {
		output?.didFinishFileTransfer(
			session: session,
			file: fileTransfer,
			error: error
		)
	}
}
