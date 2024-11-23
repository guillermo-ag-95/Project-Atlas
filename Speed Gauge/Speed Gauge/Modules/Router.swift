//
//  Router.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 23/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

class Router {
	
	enum Module {
		case chart(dto: ChartAssemblyDTO)
		case results(dto: ResultsAssemblyDTO)
	}
	
	private init() { }
	
	static func push(_ module: Module, animated: Bool = true) {
		guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			  let rootViewController = scene.windows.first?.rootViewController,
			  let navigationController = rootViewController as? UINavigationController
		else { return }
		
		let view = build(module)
		navigationController.pushViewController(view, animated: animated)
	}
	
	private static func build(_ module: Module) -> UIViewController {
		let view: UIViewController
		
		switch module {
		case let .chart(dto):
			view = ChartAssembly.viewController(assemblyDTO: dto)
		case let .results(dto):
			view = ResultsAssembly.viewController(assemblyDTO: dto)
		}
		
		return view
	}
	
}
