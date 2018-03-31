//
//  Filter_Tests.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 31/3/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest
@testable import Speed_Gauge

class Filter_Tests: Abstract_Test {
    
    let filter = Filter()
    
    func testSum(){
        let first = 6
        let last = 4
        
        let expected = 10
        let result = filter.sum(first, last)
        XCTAssert(expected == result)
    }
}
