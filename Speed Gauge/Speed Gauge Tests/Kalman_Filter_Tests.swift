//
//  Kalman_Filter_Tests.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 3/4/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest
@testable import Speed_Gauge

class Kalman_Filter_Tests: Abstract_Test {
    
    let kalman_filter = Kalman_Filter()
    
    /// Textbook example.
    func test_kalman_filter_1(){
        Kalman_Filter.filter()
    }
    
}
