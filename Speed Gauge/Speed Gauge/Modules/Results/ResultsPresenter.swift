//
//  ResultsPresenter.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 23/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

protocol ResultsPresenterProtocol: AnyObject {
	func loadResults()
	
	func removeRepetition(at index: Int)
}

class ResultsPresenter {
	weak var view: ResultsViewControllerProtocol?
	
	var assemblyDTO: ResultsAssemblyDTO?
	
	init(view: ResultsViewControllerProtocol, assemblyDTO: ResultsAssemblyDTO?) {
		self.assemblyDTO = assemblyDTO
		self.view = view
	}
	
	// MARK: - Presentation data
	private var repetitions: [MotionRepetition] = []
}

extension ResultsPresenter: ResultsPresenterProtocol {
	func loadResults() {
		let repetitions = assemblyDTO?.repetitions ?? []
		self.repetitions = repetitions
		
		view?.updateRepetitions(repetitions)
	}
	
	func removeRepetition(at index: Int) {
		self.repetitions.remove(at: index)
		
		view?.updateRepetitions(repetitions)
	}
}
