//
//  Router.swift
//  Atlas
//
//  Created by Guillermo Alcalá Gamero on 23/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

protocol RouterProtocol: AnyObject {
	func push(_ module: Router.Module, animated: Bool)
}

class Router {
	enum Module {
		case chart(dto: ChartAssemblyDTO)
		case results(dto: ResultsAssemblyDTO)
	}
	
	private init() { }
	
	static let shared: RouterProtocol = Router()
}

extension Router: RouterProtocol {
	func push(_ module: Module, animated: Bool = true) {
		guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			  let rootViewController = scene.windows.first?.rootViewController,
			  let navigationController = rootViewController as? UINavigationController
		else { return }
		
		let view = build(module)
		navigationController.pushViewController(view, animated: animated)
	}
	
	private func build(_ module: Module) -> UIViewController {
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
