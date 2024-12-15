//
//  FileManagerRepository.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 15/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

class FileManagerRepository: NSObject {
	weak var output: FileManagerRepositoryOutputProtocol?
	
	private let manager = FileManager.default
	
	init(output: FileManagerRepositoryOutputProtocol) {
		super.init()
		
		self.output = output
		self.manager.delegate = self
	}
}

extension FileManagerRepository: FileManagerRepositoryInputProtocol {
	func read(file: FileManagerRepositoryFile?) -> FileManagerRepositoryData? {
		guard let file else { return nil }
		
		let result = try? Data(contentsOf: file)
		return result
	}
	
	func save(_ data: FileManagerRepositoryData) -> FileManagerRepositoryFile? {
		let directory = manager.temporaryDirectory
		
		let fileName = UUID().uuidString
		let fileURL = directory.appendingPathComponent(fileName)
		
		do {
			try data.write(to: fileURL)
			return fileURL
		} catch {
			return nil
		}
	}
	
	func delete(file: FileManagerRepositoryFile?) {
		guard let file else { return }
		
		try? manager.removeItem(at: file)
	}
}

extension FileManagerRepository: FileManagerDelegate {
	
}
