//
//  Discrete_Bayes_Filter_Tests.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 1/4/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest
@testable import Speed_Gauge

class Discrete_Bayes_Filter_Tests: Abstract_Test {
    
    let discrete_Bayes_Filter = Discrete_Bayes_Filter()
    
    /// Textbook example
    func test_filter_1(){
        let result = discrete_Bayes_Filter.filter()
    }

}
