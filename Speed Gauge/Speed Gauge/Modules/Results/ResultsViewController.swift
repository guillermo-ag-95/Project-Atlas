//
//  ResultsViewController.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 19/5/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

protocol ResultsViewControllerProtocol: AnyObject {
	func updateRepetitions(_ repetitions: [any MotionRepetition])
}

class ResultsViewController: UIViewController {
	// MARK: - Outlets
	@IBOutlet weak var tableView: UITableView!
	
	// MARK: - Connections
	var presenter: ResultsPresenterProtocol?
	
	// MARK: - Variables
	private let repetitionCellIdentifier = RepetitionTableViewCell.nameOfClass
	private var repetitions: [any MotionRepetition] = []
	
	// MARK: - States
	
	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupNavigationBar()
		setupTableView()
		
		loadData()
	}
	
	// MARK: - Setup functions
	func setupNavigationBar() {
		title = LocalizedKeys.Common.results
	}
	
	func setupTableView() {
		let cellNib = UINib(nibName: repetitionCellIdentifier, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: repetitionCellIdentifier)
		
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	func loadData() {
		presenter?.loadResults()
	}
	
	// MARK: - Actions
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfRows = repetitions.count
		return numberOfRows
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell
		
		if let repetition = repetitions.at(indexPath.row) {
			cell = tableView.dequeueReusableCell(
				withIdentifier: repetitionCellIdentifier,
				for: indexPath
			)
			
			if let cell = cell as? RepetitionTableViewCell {
				let cellModel = RepetitionCellModel(model: repetition, at: indexPath.row)
				cell.configure(cellModel: cellModel)
			}
		} else {
			cell = .init()
		}
		
		return cell
    }
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return .zero
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return .zero
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
		case .delete:
			presenter?.removeRepetition(at: indexPath.row)
		default:
			break
		}  
    }
}

extension ResultsViewController: ResultsViewControllerProtocol {
	func updateRepetitions(_ repetitions: [any MotionRepetition]) {
		self.repetitions = repetitions
		self.tableView.reloadData()
	}
}
