//
//  ChartViewControllerMock.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 23/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

@testable import DGCharts
@testable import Speed_Gauge

class ChartViewControllerMock: ChartViewControllerProtocol {
	var setupChartDataSetCalled = false
	var resetChartDataSetCalled = false
	var reloadChartCalled = false
	var reloadChartDataSetsCalled = false
	var updateRepetitionsCalled = false
	
	func setupChartDataSet(_ dataSet: ChartDataSet, label: String, color: UIColor, pointSize: CGFloat) {
		setupChartDataSetCalled = true
	}
	
	func resetChartDataSet(_ dataSet: ChartDataSet) {
		resetChartDataSetCalled = true
	}
	
	func reloadChart() {
		reloadChartCalled = true
	}
	
	func reloadChartDataSets(_ dataSets: [any ChartDataSetProtocol]) {
		reloadChartDataSetsCalled = true
	}
	
	func updateRepetitions(_ repetitions: [any MotionRepetition]) {
		updateRepetitionsCalled = true
	}
}

