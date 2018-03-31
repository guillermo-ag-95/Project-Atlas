//
//  G_H_Filter_Tests.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 31/3/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest
@testable import Speed_Gauge

class GH_Filter_Tests: Abstract_Test {
    
    let gh_filter = GH_Filter()
    
    /// Textbook example.
    func test_predict_using_gain_guess_batch_1() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        
        let expected: [Double] = [159.8, 162.16, 162.016, 161.7696, 162.50176, 163.941056, 166.8046336, 167.64278016, 167.745668096, 169.6474008576, 170.86844051455998, 172.16106430873597]
        let result = gh_filter.predict_using_gain_guess_batch(data, initial_guess: 160.0, scale_factor: 0.4, gain_rate: 1, time_step: 1.0)
        
        XCTAssert(expected == result)
    }
    
    /// scale_factor is set to 0 so, data measurements are ignored in favor of gain_rate.
    func test_predict_using_gain_guess_batch_2() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        
        let expected: [Double] = [161.0, 162.0, 163.0, 164.0, 165.0, 166.0, 167.0, 168.0, 169.0, 170.0, 171.0, 172.0]
        let result = gh_filter.predict_using_gain_guess_batch(data, initial_guess: 160.0, scale_factor: 0, gain_rate: 1, time_step: 1.0)
        
        XCTAssert(expected == result)
    }
    
    /// scale_factor is set to 1 so, data measurements are followed, no matter what the gain_rate is.
    func test_predict_using_gain_guess_batch_3() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        
        let expected: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        let result = gh_filter.predict_using_gain_guess_batch(data, initial_guess: 160.0, scale_factor: 1, gain_rate: 1, time_step: 1.0)
        
        XCTAssert(expected == result)
    }
    
    /// Textbook example.
    func test_predict_using_adaptative_gain_batch_1() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        
        let expected: [Double] = [159.8, 161.62, 161.926, 161.46179999999998, 161.59473999999997, 162.82608199999999, 166.09706260000002, 168.23053218000001, 168.86145427400001, 170.34157124820001, 171.50717005826002, 172.67437832681802]
        let result = gh_filter.predict_using_adaptative_gain_batch(data, initial_guess: 160.0, scale_factor: 0.4, initial_gain_rate: 1, scale_gain: 0.3, time_step: 1.0)
        
        print(result)
        
        XCTAssert(expected == result)
    }
    
    /// Textbook example.
    func test_predict_using_adaptative_gain_batch_2() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        
        let expected: [Double] = [159.8, 162.16, 162.016, 161.7696, 162.50176, 163.941056, 166.8046336, 167.64278016, 167.745668096, 169.6474008576, 170.86844051455998, 172.16106430873597]
        let result = gh_filter.predict_using_adaptative_gain_batch(data, initial_guess: 160.0, scale_factor: 0.4, initial_gain_rate: 1, scale_gain: 0, time_step: 1.0)
        
        XCTAssert(expected == result)
    }
    
    /// scale_factor is set to 0 so, data measurements are ignored in favor of gain_rate.
    func test_predict_using_adaptative_gain_batch_3() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        
        let expected: [Double] = [161.0, 162.0, 163.0, 164.0, 165.0, 166.0, 167.0, 168.0, 169.0, 170.0, 171.0, 172.0]
        let result = gh_filter.predict_using_adaptative_gain_batch(data, initial_guess: 160.0, scale_factor: 0, initial_gain_rate: 1, scale_gain: 0, time_step: 1.0)
        
        XCTAssert(expected == result)
    }
    
    /// scale_factor is set to 0 so, data measurements are ignored in favor of gain_rate.
    func test_predict_using_adaptative_gain_batch_4() {
        let data: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        
        let expected: [Double] = [158.0, 164.2, 160.3, 159.9, 162.1, 164.6, 169.6, 167.4, 166.4, 171.0, 171.2, 172.6]
        let result = gh_filter.predict_using_adaptative_gain_batch(data, initial_guess: 160.0, scale_factor: 1, initial_gain_rate: 1, scale_gain: 0, time_step: 1.0)
        
        XCTAssert(expected == result)
    }
    
}
