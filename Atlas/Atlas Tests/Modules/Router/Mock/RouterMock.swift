//
//  RouterMock.swift
//  Atlas Tests
//
//  Created by Guillermo Alcalá Gamero on 24/11/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

@testable import Atlas

class RouterMock: RouterProtocol {
	var pushCalled = false
	
	func push(_ module: Router.Module, animated: Bool) {
		pushCalled = true
	}
}
