//
//  ChartAssembly.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 17/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

class ChartAssembly {
	static func navigationController(assemblyDTO: ChartAssemblyDTO? = nil) -> UINavigationController {
		let view = viewController(assemblyDTO: assemblyDTO)
		let navigationController = UINavigationController(rootViewController: view)
		
		return navigationController
	}
	
	static func viewController(assemblyDTO: ChartAssemblyDTO? = nil) -> UIViewController {
		let view = ChartViewController(nibName: ChartViewController.nameOfClass, bundle: nil)
		
		let presenter = ChartPresenter(view: view, assemblyDTO: assemblyDTO)
		view.presenter = presenter
		
		let motionService = DeviceMotionService(output: presenter)
		let repetitionsService = RepetitionsService(output: presenter)
		let watchConnectivityService = WatchConnectivityService(output: presenter)
		
		presenter.motionService = motionService
		presenter.repetitionsService = repetitionsService
		presenter.watchConnectivityService = watchConnectivityService
		
		let watchConnectivityRepository = WatchConnectivityRepository(output: watchConnectivityService)
		watchConnectivityService.repository = watchConnectivityRepository
		
		return view
	}
}

struct ChartAssemblyDTO {
	
}
