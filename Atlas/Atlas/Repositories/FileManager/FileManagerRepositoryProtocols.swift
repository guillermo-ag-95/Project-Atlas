//
//  FileManagerRepositoryProtocols.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 15/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

// MARK: - FileManager protocol
protocol FileManagerRepositoryInputProtocol: AnyObject {
	func read(
		file: FileManagerRepositoryFile?
	) -> FileManagerRepositoryData?
	
	func save(
		_ data: FileManagerRepositoryData
	) -> FileManagerRepositoryFile?
	
	func delete(
		file: FileManagerRepositoryFile?
	)
}

protocol FileManagerRepositoryOutputProtocol: AnyObject {
	
}
