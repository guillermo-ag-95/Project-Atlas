//
//  WatchConnectivityRepositoryModels.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 7/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import WatchConnectivity

// MARK: - Watch connectivity models
typealias WatchConnectivityActivationStatus = WCSessionActivationState
typealias WatchConnectivityActivationError = (any Error)?

typealias WatchConnectivityRepositoryMessageModel = [String: Any]
typealias WatchConnectivityRepositoryReplyMessageHandler = (([String : Any]) -> Void)?
typealias WatchConnectivityRepositoryErrorMessageHandler = ((any Error) -> Void)?

typealias WatchConnectivityRepositoryDataModel = Data
typealias WatchConnectivityRepositoryReplyDataHandler = ((Data) -> Void)?
typealias WatchConnectivityRepositoryErrorDataHandler = ((any Error) -> Void)?
