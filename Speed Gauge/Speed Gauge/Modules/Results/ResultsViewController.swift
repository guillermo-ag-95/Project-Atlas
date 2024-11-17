//
//  ResultsViewController.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 19/5/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
	// MARK: - Outlets
	@IBOutlet weak var tableView: UITableView!
	
	// MARK: - Connections
	// TODO: Move to presenter when available
	var assemblyDTO: ResultsAssemblyDTO?
	
	// MARK: - Variables
	private let repetitionCellIdentifier = RepetitionTableViewCell.nameOfClass
	lazy var repetitions = assemblyDTO?.repetitions ?? []
	
	// MARK: - States
	
	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupNavigationBar()
		setupTableView()
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
		
		if let repetition = repetitions.at(indexPath.section) {
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
			repetitions.remove(at: indexPath.section)
			tableView.reloadData()
		default:
			break
		}  
    }
}
