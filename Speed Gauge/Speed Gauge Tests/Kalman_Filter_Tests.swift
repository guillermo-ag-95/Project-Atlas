//
//  Kalman_Filter_Tests.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 3/4/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest

import Surge
@testable import Speed_Gauge

class Kalman_Filter_Tests: Abstract_Test {
    
    func test_init_1(){

        let dt: Double = 1

        let x = Matrix<Double>([[10.0],[4.5]])
        let P = Matrix<Double>([[500, 0],[0, 49]])
        let F = Matrix<Double>([[1, dt],[0, 1]])
        let Q = Matrix<Double>([[0.588, 1.175], [1.175, 2.35]]) // This calculation will be explained later
        let B = Matrix<Double>(rows: F.rows, columns: F.columns, repeatedValue: 0)
        let u = Matrix<Double>(rows: x.rows, columns: x.columns, repeatedValue: 0)
        
        let H = Matrix<Double>([[1,0]])
        let R = Matrix<Double>([[5]])
        
        let kalman_filter = Kalman_Filter.init(x, P, F, Q, B, u, H, R)
        
        XCTAssertEqual(kalman_filter.x, x)
        XCTAssertEqual(kalman_filter.P, P)
        XCTAssertEqual(kalman_filter.F, F)
        XCTAssertEqual(kalman_filter.Q, Q)
        XCTAssertEqual(kalman_filter.B, B)
        XCTAssertEqual(kalman_filter.u, u)
        XCTAssertEqual(kalman_filter.H, H)
        XCTAssertEqual(kalman_filter.R, R)
    }
    
    /// Textbook example.
//    func test_kalman_filter_1(){
//
//        let dt: Double = 1
//
//        let x = Matrix<Double>([[10.0],[4.5]])
//        let P = Matrix<Double>([[500, 0],[0, 49]])
//        let F = Matrix<Double>([[1, dt],[0, 1]])
//        let Q = Matrix<Double>([[0.588, 1.175], [1.175, 2.35]]) // This calculation will be explained later
//        let B = Matrix<Double>(rows: F.rows, columns: F.columns, repeatedValue: 0)
//        let u = Matrix<Double>(rows: x.rows, columns: x.columns, repeatedValue: 0)
//
//        let z = Matrix<Double>([[1]])
//        let H = Matrix<Double>([[1,0]])
//        let R = Matrix<Double>([[5]])
//    }
    
}
