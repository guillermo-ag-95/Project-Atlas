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

        let dt: Double = 0.1

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
    func test_kalman_filter_predict_1(){

        let dt: Double = 0.1

        let x = Matrix<Double>([[10.0],[4.5]])
        let P = Matrix<Double>([[500, 0],[0, 49]])
        
        let F = Matrix<Double>([[1, dt],[0, 1]])
        let Q = Matrix<Double>([[0.588, 1.175], [1.175, 2.35]]) // This calculation will be explained later
        let B = Matrix<Double>(rows: F.rows, columns: F.columns, repeatedValue: 0)
        let u = Matrix<Double>(rows: x.rows, columns: x.columns, repeatedValue: 0)

        let H = Matrix<Double>([[1,0]])
        let R = Matrix<Double>([[5]])
        
        let kalman_filter = Kalman_Filter.init(x, P, F, Q, B, u, H, R)
        
        let x_expected = Matrix<Double>([[10.45],[4.5]])
        let P_expected = Matrix<Double>([[501.078, 6.075],[6.075, 51.35]])
        let (x_prior, P_prior) = kalman_filter.predict()
        
        // Check matrix values.
        for m in 0..<x_prior.rows {
            for n in 0..<x_prior.columns {
                XCTAssertEqual(x_expected[m,n], x_prior[m,n], accuracy: 0.01)
            }
        }
        
        for m in 0..<P_prior.rows {
            for n in 0..<P_prior.columns {
                XCTAssertEqual(P_expected[m,n], P_prior[m,n], accuracy: 0.01)
            }
        }
        
    }
    
    /// Textbook example.
    func test_kalman_filter_update_1(){
        
        let dt: Double = 0.1
        
        var x = Matrix<Double>([[10.0],[4.5]])
        var P = Matrix<Double>([[500, 0],[0, 49]])
        
        let F = Matrix<Double>([[1, dt],[0, 1]])
        let Q = Matrix<Double>([[0.588, 1.175], [1.175, 2.35]]) // This calculation will be explained later
        let B = Matrix<Double>(rows: F.rows, columns: F.columns, repeatedValue: 0)
        let u = Matrix<Double>(rows: x.rows, columns: x.columns, repeatedValue: 0)
        
        let z = Matrix<Double>([[1]])
        let H = Matrix<Double>([[1,0]])
        let R = Matrix<Double>([[5]])
        
        let kalman_filter = Kalman_Filter.init(x, P, F, Q, B, u, H, R)
        
        let x_expected = Matrix<Double>([[1.093],[4.387]])
        let P_expected = Matrix<Double>([[4.951, 0.060],[0.060, 51.277]])
        let (x_prior, P_prior) = kalman_filter.predict()
        (x, P) = kalman_filter.update(x_prior, P_prior, z)
        
        // Check matrix values.
        for m in 0..<kalman_filter.x.rows {
            for n in 0..<kalman_filter.x.columns {
                XCTAssertEqual(x_expected[m,n], kalman_filter.x[m,n], accuracy: 0.01)
            }
        }
        
        for m in 0..<kalman_filter.P.rows {
            for n in 0..<kalman_filter.P.columns {
                XCTAssertEqual(P_expected[m,n], kalman_filter.P[m,n], accuracy: 0.01)
            }
        }
        
    }
    
    /// Textbook example.
    func test_kalman_filter_1(){
        
        let dt: Double = 0.1
        
        var x = Matrix<Double>([[10.0],[4.5]])
        var P = Matrix<Double>([[500, 0],[0, 49]])
        
        let F = Matrix<Double>([[1, dt],[0, 1]])
        let Q = Matrix<Double>([[0.588, 1.175], [1.175, 2.35]]) // This calculation will be explained later
        let B = Matrix<Double>(rows: F.rows, columns: F.columns, repeatedValue: 0)
        let u = Matrix<Double>(rows: x.rows, columns: x.columns, repeatedValue: 0)
        
        let z = Matrix<Double>([[1]])
        let H = Matrix<Double>([[1,0]])
        let R = Matrix<Double>([[5]])
        
        let kalman_filter = Kalman_Filter.init(x, P, F, Q, B, u, H, R)
        
        let x_expected = Matrix<Double>([[1.093],[4.387]])
        let P_expected = Matrix<Double>([[4.951, 0.060],[0.060, 51.277]])
        (x, P) = kalman_filter.filter(z)
        
        // Check matrix values.
        for m in 0..<kalman_filter.x.rows {
            for n in 0..<kalman_filter.x.columns {
                XCTAssertEqual(x_expected[m,n], kalman_filter.x[m,n], accuracy: 0.01)
            }
        }
        
        for m in 0..<kalman_filter.P.rows {
            for n in 0..<kalman_filter.P.columns {
                XCTAssertEqual(P_expected[m,n], kalman_filter.P[m,n], accuracy: 0.01)
            }
        }
        
    }
    
}
