//
//  ResultsAssembly.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 17/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

class ResultsAssembly {
	static func navigationController(assemblyDTO: ResultsAssemblyDTO? = nil) -> UINavigationController {
		let viewController = viewController(assemblyDTO: assemblyDTO)
		let navigationController = UINavigationController(rootViewController: viewController)
		
		return navigationController
	}
	
	static func viewController(assemblyDTO: ResultsAssemblyDTO? = nil) -> UIViewController {
		let viewController = ResultsViewController(nibName: ResultsViewController.nameOfClass, bundle: nil)
		
		viewController.assemblyDTO = assemblyDTO
		
		return viewController
	}
}

struct ResultsAssemblyDTO {
	let repetitions: [MotionRepetition]
}
