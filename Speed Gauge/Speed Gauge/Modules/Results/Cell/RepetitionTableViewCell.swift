//
//  RepetitionTableViewCell.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 17/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

class RepetitionTableViewCell: UITableViewCell {
	// MARK: - Outlets
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	
	// MARK: - Variables
	var cellModel: RepetitionCellModel?
	
	// MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	// MARK: - Setup functions
	func configure(cellModel: RepetitionCellModel) {
		self.cellModel = cellModel
		
		self.titleLabel.text = cellModel.title
		self.subtitleLabel.text = cellModel.subtitle
	}
}
