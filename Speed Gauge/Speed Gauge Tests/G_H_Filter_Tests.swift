//
//  G_H_Filter_Tests.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 31/3/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest
@testable import Speed_Gauge

class G_H_Filter_Tests: Abstract_Test {
    
    let g_h_filter = G_H_Filter()
    
    /// Textbook example.
    func test_fiter_1() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]

        let expected: [Double] = [159.8, 161.62, 161.926, 161.46179999999998, 161.59473999999997, 162.82608199999999, 166.09706260000002, 168.23053218000001, 168.86145427400001, 170.34157124820001, 171.50717005826002, 172.67437832681802]
        let result = g_h_filter.filter(data, x0: 160.0, dx: 1, g: 0.4, h: 0.3, dt: 1.0)
        
        XCTAssert(expected == result)
    }
    
    /// g is set to 0 so, measurements are ignored in favor of dx.
    func test_fiter_2() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        
        let expected: [Double] = [161.0, 162.0, 163.0, 164.0, 165.0, 166.0, 167.0, 168.0, 169.0, 170.0, 171.0, 172.0]
        let result = g_h_filter.filter(data, x0: 160.0, dx: 1, g: 0, h: 0, dt: 1.0)
        
        XCTAssert(expected == result)
    }
    
    /// g is set to 1 so, predictions are ignored in favor of the measurements.
    func test_fiter_3() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        
        let expected: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        let result = g_h_filter.filter(data, x0: 160.0, dx: 1, g: 1, h: 0, dt: 1.0)
        
        XCTAssert(expected == result)
    }
    
}
