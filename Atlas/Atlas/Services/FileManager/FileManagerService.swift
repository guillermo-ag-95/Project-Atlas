//
//  FileManagerService.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 15/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

typealias FileManagerServiceInputProtocol = FileManagerRepositoryInputProtocol
typealias FileManagerServiceOutputProtocol = FileManagerRepositoryOutputProtocol

class FileManagerService {
	weak var output: FileManagerServiceOutputProtocol?
	internal var repository: FileManagerRepositoryInputProtocol?
	
	init(output: FileManagerServiceOutputProtocol) {
		self.output = output
	}
}

extension FileManagerService: FileManagerServiceInputProtocol {
	func read(file: FileManagerRepositoryFile?) -> FileManagerRepositoryData? {
		repository?.read(file: file)
	}
	
	func save(_ data: FileManagerRepositoryData) -> FileManagerRepositoryFile? {
		repository?.save(data)
	}
	
	func delete(file: FileManagerRepositoryFile?) {
		repository?.delete(file: file)
	}
}

extension FileManagerService: FileManagerServiceOutputProtocol {
	
}
