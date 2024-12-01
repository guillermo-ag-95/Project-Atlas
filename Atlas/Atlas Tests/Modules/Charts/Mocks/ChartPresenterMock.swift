//
//  ChartPresenterMock.swift
//  Atlas Tests
//
//  Created by Guillermo Alcalá Gamero on 23/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

@testable import Atlas

class ChartPresenterMock: ChartPresenterProtocol {
	var setupChartsCalled = false
	var resetChartsCalled = false
	var loadChartsCalled = false
	var loadChartAtPositionCalled = false
	var startMeasuresCalled = false
	var stopMeasuresCalled = false
	var goToResultsCalled = false
	
	func setupCharts() {
		setupChartsCalled = true
	}
	
	func resetCharts() {
		resetChartsCalled = true
	}
	
	func loadCharts() {
		loadChartsCalled = true
	}
	
	func loadChart(at position: Int) {
		loadChartAtPositionCalled = true
	}
	
	func startMeasures() {
		startMeasuresCalled = true
	}
	
	func stopMeasures() {
		stopMeasuresCalled = true
	}
	
	func goToResults() {
		goToResultsCalled = true
	}
}
