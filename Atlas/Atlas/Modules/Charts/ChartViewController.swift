//
//  ChartViewController.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 16/11/17.
//  Copyright © 2017 Guillermo Alcalá Gamero. All rights reserved.
//

import DGCharts
import UIKit
import WatchConnectivity

protocol ChartViewControllerProtocol: AnyObject {
	func setupChartDataSet(_ dataSet: ChartDataSet, label: String, color: UIColor, pointSize: CGFloat)
	func resetChartDataSet(_ dataSet: ChartDataSet)
	func reloadChart()
	func reloadChartDataSets(_ dataSets: [ChartDataSetProtocol])
	func updateRepetitions(_ repetitions: [MotionRepetition])
}

class ChartViewController: UIViewController {
	// MARK: - Outlets
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBOutlet weak var lineChartView: LineChartView!
	@IBOutlet weak var actionButton: UIButton!
	
	// MARK: - Connections
	var presenter: ChartPresenterProtocol?
	var watchConnectivitySession: WCSession? = WCSession.default
	
	// MARK: - Variables
	private var repetitions: [any MotionRepetition] = []
	
	// MARK: - States
	var isPaused = true {
		didSet {
			guard isPaused != oldValue else { return }
			
			setupButtons()
			vibrateDevice()
			notifyWatch()
			
			let willPause = isPaused
			willPause ? stopRecordData() : startRecordData()
		}
	}
	
	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupNavigationBar()
		setupHeader()
		setupCharts()
		setupButtons()
		setupWatch()
	}
	
	// MARK: - Setup functions
	func setupNavigationBar() {
		title = LocalizedKeys.Common.graphs
		
		guard let navigationController else { return }
		
		let rightBarButtonItem = UIBarButtonItem(
			title: LocalizedKeys.Common.results,
			style: .plain, target: self,
			action: #selector(rightBarButtonTapped)
		)
		
		navigationController.navigationBar.topItem?.rightBarButtonItem = rightBarButtonItem
	}
	
	func setupHeader() {
		segmentedControl.setTitle(MotionCharts.ACCELERATION.title, forSegmentAt: MotionCharts.ACCELERATION.rawValue)
		segmentedControl.setTitle(MotionCharts.VELOCITY.title, forSegmentAt: MotionCharts.VELOCITY.rawValue)
		segmentedControl.setTitle(MotionCharts.GRAVITY.title, forSegmentAt: MotionCharts.GRAVITY.rawValue)
		segmentedControl.selectedSegmentIndex = MotionCharts.VELOCITY.rawValue
	}
	
	func setupCharts() {
		lineChartView.chartDescription.text = MotionCharts(rawValue: segmentedControl.selectedSegmentIndex)?.description
		
		presenter?.setupCharts()
	}
	
	func setupButtons() {
		let actionButtonImage: UIImage? = isPaused ? .systemPlayFill : .systemPauseFill
		actionButton.setImage(actionButtonImage, for: .normal)
	}
	
	func setupWatch() {
		guard WCSession.isSupported() else { return }
		
		watchConnectivitySession?.delegate = self
		watchConnectivitySession?.activate()
	}
	
	// MARK: - Actions
	@IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
		presenter?.loadCharts()
	}
	
	@IBAction func actionButtonPressed(_ sender: UIButton) {
		let willPause = !isPaused
		self.isPaused = willPause
	}
	
	private func startRecordData() {
		presenter?.startMeasures()
	}
	
	private func stopRecordData() {
		presenter?.stopMeasures()
	}
	
	@objc func rightBarButtonTapped() {
		presenter?.goToResults()
	}
	
	func notifyWatch() {
		guard let watchConnectivitySession, watchConnectivitySession.isReachable else { return }
		
		let message: [String: Any] = ["isPaused": isPaused]
		
		watchConnectivitySession.sendMessage(message) { reply in
			print("G - \(Self.self) - \(#function) - reply: \(reply)")
		} errorHandler: { error in
			print("G - \(Self.self) - \(#function) - error: \(error)")
		}
	}
}

// MARK: - ChartViewControllerProtocol
extension ChartViewController: ChartViewControllerProtocol {
	/// Configure the data set.
	/// - Parameters:
	///   - dataSet: The data set to configure.
	///   - label: The text to identify the data set in the chart.
	///   - color: The color of the data entries in the chart.
	///   - pointSize: The size of the data entries in the chart.
	func setupChartDataSet(_ dataSet: ChartDataSet, label: String, color: UIColor, pointSize: CGFloat = 1) {
		dataSet.label = label
		dataSet.colors = [color]
		
		guard let dataSet = dataSet as? LineChartDataSet else { return }
		dataSet.setCircleColor(color)
		dataSet.circleRadius = pointSize
		dataSet.circleHoleRadius = pointSize
	}
	
	
	/// Reload the chart with the data set of the selected data.
	func reloadChart() {
		let selectedChart = segmentedControl.selectedSegmentIndex
		presenter?.loadChart(at: selectedChart)
	}
	
	
	/// Reload the chart with a new set of data entries.
	/// - Parameter dataSets: The new data entries to display in the chart.
	func reloadChartDataSets(_ dataSets: [ChartDataSetProtocol]) {
		let chartData = LineChartData(dataSets: dataSets)
		lineChartView.data = chartData
		lineChartView.notifyDataSetChanged()
	}
	
	/// Removes all entries a data set.
	/// - Parameter dataSet: The data set we want to remove all the entries from.
	func resetChartDataSet(_ dataSet: ChartDataSet) {
		// keepingCapacity must be true to keep dataset style.
		dataSet.removeAll(keepingCapacity: true)
	}
	
	
	/// Updates the repetitions computed based on the motion data.
	/// - Parameter repetitions: The repetitions computed based on the motion data.
	func updateRepetitions(_ repetitions: [any MotionRepetition]) {
		self.repetitions = repetitions
	}
}

extension ChartViewController: WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
		print("G - \(Self.self) - \(#function) - session: \(session) - activationState: \(activationState) - error: \(String(describing: error))")
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		print("G - \(Self.self) - \(#function) - session: \(session)")
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		print("G - \(Self.self) - \(#function) - session: \(session)")
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		print("G - \(Self.self) - \(#function) - session: \(session) - message: \(message)")
		
		runOnMainThreadIfNecessary { [weak self] in
			self?.updateState(message: message)
		}
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		print("G - \(Self.self) - \(#function) - session: \(session) - message: \(message) - replyHandler: \(String(describing: replyHandler))")
		
		runOnMainThreadIfNecessary { [weak self] in
			self?.updateState(message: message)
		}
	}
	
	private func updateState(message: [String: Any]) {
		guard let isPaused = message["isPaused"] as? Bool else { return }
		self.isPaused = isPaused
	}
}
