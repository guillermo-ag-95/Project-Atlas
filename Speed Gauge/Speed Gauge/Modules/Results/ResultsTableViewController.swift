//
//  ResultsTableViewController.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 19/5/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {

	var repetitions: [MotionRepetition] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
		let result = repetitions.count
        return result
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repetitionCell", for: indexPath)
		
		let maxVelocityTitle = LocalizedKeys.Velocity.max
		let meanVelocityTitle = LocalizedKeys.Velocity.mean
		let durationTitle = LocalizedKeys.Velocity.duration
		let title = [maxVelocityTitle, meanVelocityTitle, durationTitle].joined(separator: "\n")
		
		let repetition = repetitions.at(indexPath.section)
		
		let maxVelocityValue = repetition?.maxVelocity ?? .zero
		let meanVelocityValue = repetition?.meanVelocity ?? .zero
		let metersPerSecond = LocalizedKeys.Repetition.metersPerSecond
		
		let durationValue = repetition?.duration ?? .zero
		let seconds = LocalizedKeys.Repetition.seconds
		
		let maxVelocity = String(format: "%.2f %@", maxVelocityValue, metersPerSecond)
		let meanVelocity = String(format: "%.2f %@", meanVelocityValue, metersPerSecond)
		let duration = String(format: "%.2f %@", durationValue, seconds)
		let detail = [maxVelocity, meanVelocity, duration].joined(separator: "\n")
		
        cell.textLabel?.text = title
		cell.textLabel?.numberOfLines = .zero
		
		cell.detailTextLabel?.text = detail
		cell.detailTextLabel?.numberOfLines = .zero

        return cell
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let repetition = LocalizedKeys.Repetition.title
		let number = section + 1
		let result = String(format: "%@ %d", repetition, number)
		
		return result
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
		case .delete:
			repetitions.remove(at: indexPath.section)
			tableView.reloadData()
		default:
			break
		}  
    }
}
