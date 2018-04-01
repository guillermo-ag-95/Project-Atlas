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
    
    let g_H_Filter = G_H_Filter()
    
    /// Textbook example.
    func test_fiter_1() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]

        let expected: [Double] = [159.8, 161.62, 161.92, 161.46, 161.59, 162.82, 166.09, 168.23, 168.86, 170.34, 171.50, 172.67]
        let result = g_H_Filter.filter(data, x0: 160.0, dx: 1, g: 0.4, h: 0.3, dt: 1.0)
        
        _ = zip(expected, result).map { XCTAssertEqual($0, $1, accuracy: 0.1) }
        
    }
    
    /// g is set to 0 so, measurements are ignored in favor of dx.
    func test_fiter_2() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        
        let expected: [Double] = [161.0, 162.0, 163.0, 164.0, 165.0, 166.0, 167.0, 168.0, 169.0, 170.0, 171.0, 172.0]
        let result = g_H_Filter.filter(data, x0: 160.0, dx: 1, g: 0, h: 0, dt: 1.0)
        
        _ = zip(expected, result).map { XCTAssertEqual($0, $1, accuracy: 0.1) }
        
        XCTAssert(expected == result)
    }
    
    /// g is set to 1 so, predictions are ignored in favor of the measurements.
    func test_fiter_3() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        
        let expected: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        let result = g_H_Filter.filter(data, x0: 160.0, dx: 1, g: 1, h: 0, dt: 1.0)
        
        _ = zip(expected, result).map { XCTAssertEqual($0, $1, accuracy: 0.1) }
        
        XCTAssert(expected == result)
    }
    
    /// Textbook example
    func test_gen_data_1(){
        let result = g_H_Filter.gen_data(x0: 0, dx: 1, count: 100, noise_factor: 1)
        
        XCTAssert(result.count == 100)
    }
    
    /// Clean data
    func test_gen_data_2(){
        let expected = Array(0...99).map { Double($0) }
        let result = g_H_Filter.gen_data(x0: 0, dx: 1, count: 100, noise_factor: 0)
        
        XCTAssert(expected.count == result.count)
        XCTAssert(expected == result)
    }
    
}
