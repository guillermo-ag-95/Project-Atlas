//
//  ResultsAssembly.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 17/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

class ResultsAssembly {
	static func navigationController(assemblyDTO: ResultsAssemblyDTO? = nil) -> UINavigationController {
		let view = viewController(assemblyDTO: assemblyDTO)
		let navigationController = UINavigationController(rootViewController: view)
		
		return navigationController
	}
	
	static func viewController(assemblyDTO: ResultsAssemblyDTO? = nil) -> UIViewController {
		let view = ResultsViewController(nibName: ResultsViewController.nameOfClass, bundle: nil)
		
		let presenter = ResultsPresenter(view: view, assemblyDTO: assemblyDTO)
		view.presenter = presenter
		
		return view
	}
}

struct ResultsAssemblyDTO {
	let repetitions: [MotionRepetition]
}
