//
//  ChartViewControllerTests.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 23/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest

@testable import Speed_Gauge

final class ChartViewControllerTests: XCTestCase {
	
	var view: ChartViewController?
	var presenterMock: ChartPresenterMock?
	
    override func setUpWithError() throws {
		super.setUp()
		
		let presenterMock = ChartPresenterMock()
		
		let view = ChartViewController()
		view.presenter = presenterMock
		
		self.presenterMock = presenterMock
		self.view = view

		self.view?.beginAppearanceTransition(true, animated: false)
    }

    override func tearDownWithError() throws {
		super.tearDown()
		
		self.view?.endAppearanceTransition()
		
		self.presenterMock = nil
		self.view = nil
    }
	
	func test_viewDidLoad() {
		view?.viewDidLoad()
		
		let result = presenterMock?.setupChartsCalled
		XCTAssert(result.isTrue)
	}
	
	func test_segmentedControlChanged() {
		view?.segmentedControlChanged(.init())
		
		let result = presenterMock?.loadChartsCalled
		XCTAssert(result.isTrue)
	}
	
	func test_actionButtonPressed_fromPauseToPlay() {
		view?.isPaused = true
		
		view?.actionButtonPressed(.init())
		
		let result = presenterMock?.startMeasuresCalled
		XCTAssert(result.isTrue)
	}
	
	func test_actionButtonPressed_fromPlayToPause() {
		view?.isPaused = false
		
		view?.actionButtonPressed(.init())
		
		let result = presenterMock?.stopMeasuresCalled
		XCTAssert(result.isTrue)
	}
	
	func test_rightBarButtonTapped() {
		view?.rightBarButtonTapped()
		
		let result = presenterMock?.goToResultsCalled
		XCTAssert(result.isTrue)
	}
}
