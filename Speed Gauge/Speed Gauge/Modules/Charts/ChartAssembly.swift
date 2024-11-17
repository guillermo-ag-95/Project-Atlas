//
//  ChartAssembly.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 17/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

class ChartAssembly {
	static func navigationController(assemblyDTO: ChartAssemblyDTO? = nil) -> UINavigationController {
		let viewController = viewController(assemblyDTO: assemblyDTO)
		let navigationController = UINavigationController(rootViewController: viewController)
		
		return navigationController
	}
	
	static func viewController(assemblyDTO: ChartAssemblyDTO? = nil) -> UIViewController {
		let viewController = ChartViewController(nibName: ChartViewController.nameOfClass, bundle: nil)
		
		let presenter = ChartPresenter(view: viewController, assemblyDTO: assemblyDTO)
		viewController.presenter = presenter
		
		let motionService = DeviceMotionService(output: presenter)
		let repetitionsService = RepetitionsService(output: presenter)
		
		presenter.motionService = motionService
		presenter.repetitionsService = repetitionsService
		
		return viewController
	}
}

struct ChartAssemblyDTO {
	
}
