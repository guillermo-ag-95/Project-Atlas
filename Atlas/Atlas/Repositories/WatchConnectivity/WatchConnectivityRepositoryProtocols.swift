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
}

// MARK: - WatchConnectivityRepositoryOutputProtocol
protocol WatchConnectivityRepositoryOutputProtocol: AnyObject {
	func didCompleteWith(
		status: WatchConnectivityActivationStatus,
		error: WatchConnectivityActivationError
	)
	
	func didBecomeInactive()
	func didDeactivate()
	
	func didReceiveMessage(
		_ message: WatchConnectivityRepositoryMessageModel,
		reply: WatchConnectivityRepositoryReplyMessageHandler
	)
	
	func didReceiveData(
		_ data: WatchConnectivityRepositoryDataModel,
		reply: WatchConnectivityRepositoryReplyDataHandler
	)
}

extension WatchConnectivityRepositoryOutputProtocol {
	func didCompleteWith(
		status: WatchConnectivityActivationStatus,
		error: WatchConnectivityActivationError
	) { }
	
	func didBecomeInactive() { }
	func didDeactivate() { }
	
	func didReceiveMessage(
		_ message: WatchConnectivityRepositoryMessageModel,
		reply: WatchConnectivityRepositoryReplyMessageHandler
	) { }
	
	func didReceiveData(
		_ data: WatchConnectivityRepositoryDataModel,
		reply: WatchConnectivityRepositoryReplyDataHandler
	) { }
}
