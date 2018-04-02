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
        let position = Gaussian(mean: 10.0, variance: 0.2*0.2)
        let velocity = Gaussian(mean: 15.0, variance: 0.7*0.7)
        
        let prior = Gaussian.predict(lhs: position, rhs: velocity)
        
        XCTAssertEqual(prior.mean, 25.0, accuracy: 0.01)
        XCTAssertEqual(prior.variance, 0.53, accuracy: 0.01)
    }
    
    func test_gaussian_2(){
        let prior = Gaussian(mean: 25.0, variance: 0.53)
        let likehood = Gaussian(mean: 23.0, variance: 0.16*0.16)
        
        let posterior = Gaussian.update(lhs: prior, rhs: likehood)
        
        XCTAssertEqual(posterior.mean, 23.0921526278, accuracy: 0.01)
        XCTAssertEqual(posterior.variance, 0.02442044636, accuracy: 0.01)
    }
    
    func test_fist_kalman_filter_1(){
        let process_var = 1.0 // Variance of the movement.
        let sensor_var = 2.0 // Variance of the sensor.
        
        var x = Gaussian(mean: 0.0, variance: 20.0*20.0) // Initial position.
        
        let velocity = 1
        let dt = 1.0 // Time steps in seconds.
        let process_model = Gaussian(mean: Double(velocity)*dt, variance: process_var)
        
        let zs = [1.354, 1.882, 4.341, 7.156, 6.939, 6.844, 9.847, 12.553, 16.273, 14.800]
        
        // Perform Kalman filter on measurements z
        for z in zs {
            let prior = Gaussian.predict(lhs: x, rhs: process_model)
            let likehood = Gaussian(mean: z, variance: sensor_var)
            x = Gaussian.update(lhs: prior, rhs: likehood)
        }
        
        XCTAssertEqual(x.mean, 15.053, accuracy: 0.01)
    }

}
