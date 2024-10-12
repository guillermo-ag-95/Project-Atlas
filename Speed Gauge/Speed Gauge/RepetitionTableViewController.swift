//
//  ResultsTableViewController.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 19/5/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

class RepetitionTableViewController: UITableViewController {

    var maxVelocities: [Double] = []
    var meanVelocities: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		let result = maxVelocities.count
        return result
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repetitionCell", for: indexPath)
		
		let maxVelocityTitle = LocalizedKeys.Velocity.max
		let meanVelocityTitle = LocalizedKeys.Velocity.mean
		let title = [maxVelocityTitle, meanVelocityTitle].joined(separator: "\n")
		
		let metersPerSecond = LocalizedKeys.Repetition.metersPerSecond
		
        let maxVelocity = String(format: "%.2f %@", maxVelocities[indexPath.section], metersPerSecond)
        let meanVelocity = String(format: "%.2f %@", meanVelocities[indexPath.section], metersPerSecond)
		let detail = [maxVelocity, meanVelocity].joined(separator: "\n")
		
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
	
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            maxVelocities.remove(at: indexPath.section)
            meanVelocities.remove(at: indexPath.section)
            // Delete the row from the data source
            // tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
