//
//  One_Dimensional_Kalman_Filter_Tests.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 1/4/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest
@testable import Speed_Gauge

class One_Dimensional_Kalman_Filter_Tests: Abstract_Test {

    let one_Dimensional_Kalman_Filter_Tests = One_Dimensional_Kalman_Filter()
    
    func test_gaussian_1(){
        let gaussian_1 = Gaussian(mean: 10.0, variance: 0.2*0.2)
        let gaussian_2 = Gaussian(mean: 15.0, variance: 0.7*0.7)
        
        let gaussian_3 = Gaussian.predict(lhs: gaussian_1, rhs: gaussian_2)
        
        XCTAssertEqual(gaussian_3.mean, 25.0, accuracy: 0.001)
        XCTAssertEqual(gaussian_3.variance, 0.53, accuracy: 0.001)
    }
    
    func test_gaussian_2(){
        let gaussian_1 = Gaussian(mean: 10.0, variance: 0.2*0.2)
        let gaussian_2 = Gaussian(mean: 15.0, variance: 0.7*0.7)
        
        let gaussian_3 = Gaussian.update(lhs: gaussian_1, rhs: gaussian_2)
        
        XCTAssertEqual(gaussian_3.mean, 10.377358490566, accuracy: 0.001)
        XCTAssertEqual(gaussian_3.variance, 0.0369811320754717, accuracy: 0.001)
    }

}
