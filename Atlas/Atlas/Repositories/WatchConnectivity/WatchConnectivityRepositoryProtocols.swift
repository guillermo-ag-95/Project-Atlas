//
//  WatchConnectivityRepositoryProtocols.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 7/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

// MARK: - WatchConnectivityRepositoryInputProtocol
protocol WatchConnectivityRepositoryInputProtocol: AnyObject {
	var output: WatchConnectivityRepositoryOutputProtocol? { get set }
	
	var isSupported: Bool { get }
	var isReachable: Bool { get }
	
	func sendMessage(
		_ message: WatchConnectivityRepositoryMessageModel,
		reply: WatchConnectivityRepositoryReplyMessageHandler,
		error: WatchConnectivityRepositoryErrorMessageHandler
	)
	
	func sendData(
		_ data: WatchConnectivityRepositoryDataModel,
		reply: WatchConnectivityRepositoryReplyDataHandler,
		error: WatchConnectivityRepositoryErrorDataHandler
	)
	
	func transferUserInfo(
		_ info: WatchConnectivityRepositoryUserInfo
	)
	
	func transferFile(
		_ file: WatchConnectivityRepositoryFileURL
	)
}

// MARK: - WatchConnectivityRepositoryOutputProtocol
protocol WatchConnectivityRepositoryOutputProtocol: AnyObject {
	func didCompleteWith(
		session: WatchConnectivitySession,
		status: WatchConnectivityActivationStatus,
		error: WatchConnectivityActivationError
	)
	
	func didBecomeInactive(
		session: WatchConnectivitySession
	)
	
	func didDeactivate(
		session: WatchConnectivitySession
	)
	
	func didReceiveMessage(
		session: WatchConnectivitySession,
		message: WatchConnectivityRepositoryMessageModel,
		reply: WatchConnectivityRepositoryReplyMessageHandler
	)
	
	func didReceiveData(
		session: WatchConnectivitySession,
		data: WatchConnectivityRepositoryDataModel,
		reply: WatchConnectivityRepositoryReplyDataHandler
	)
	
	func didReceiveUserInfo(
		session: WatchConnectivitySession,
		userInfo: WatchConnectivityRepositoryUserInfo
	)
	
	func didFinishUserInfoTransfer(
		session: WatchConnectivitySession,
		userInfo: WatchConnectivityRepositoryUserInfoTransfer,
		error: WatchConnectivityRepositoryError
	)
	
	func didReceiveFile(
		session: WatchConnectivitySession,
		file: WatchConnectivityRepositoryFile
	)
	
	func didFinishFileTransfer(
		session: WatchConnectivitySession,
		file: WatchConnectivityRepositoryFileTransfer,
		error: WatchConnectivityRepositoryError
	)
}

extension WatchConnectivityRepositoryOutputProtocol {
	func didCompleteWith(
		session: WatchConnectivitySession,
		status: WatchConnectivityActivationStatus,
		error: WatchConnectivityActivationError
	) { }
	
	func didBecomeInactive(
		session: WatchConnectivitySession
	) { }
	
	func didDeactivate(
		session: WatchConnectivitySession
	) { }
	
	func didReceiveMessage(
		session: WatchConnectivitySession,
		message: WatchConnectivityRepositoryMessageModel,
		reply: WatchConnectivityRepositoryReplyMessageHandler
	) { }
	
	func didReceiveData(
		session: WatchConnectivitySession,
		data: WatchConnectivityRepositoryDataModel,
		reply: WatchConnectivityRepositoryReplyDataHandler
	) { }
	
	func didReceiveUserInfo(
		session: WatchConnectivitySession,
		userInfo: WatchConnectivityRepositoryUserInfo
	) { }
	
	func didFinishUserInfoTransfer(
		session: WatchConnectivitySession,
		userInfo: WatchConnectivityRepositoryUserInfoTransfer,
		error: WatchConnectivityRepositoryError
	) { }
	
	func didReceiveFile(
		session: WatchConnectivitySession,
		file: WatchConnectivityRepositoryFile
	) { }
	
	func didFinishFileTransfer(
		session: WatchConnectivitySession,
		file: WatchConnectivityRepositoryFileTransfer,
		error: WatchConnectivityRepositoryError
	) { }
}
