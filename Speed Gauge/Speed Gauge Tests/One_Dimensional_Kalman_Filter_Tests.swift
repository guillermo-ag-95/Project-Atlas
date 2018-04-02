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
        
        let expected_predict_means = [1.000, 2.352, 3.070, 4.736, 6.960, 7.949, 8.396, 10.122, 12.338, 15.305]
        let expected_predict_variances = [401.000, 2.990, 2.198, 2.047, 2.012, 2.003, 2.001, 2.000, 2.000, 2.000]
        let expected_update_means = [1.352, 2.070, 3.736, 5.960, 6.949, 7.396, 9.122, 11.338, 14.305, 15.053]
        let expected_update_variances = [1.990, 1.198, 1.047, 1.012, 1.003, 1.001, 1.000, 1.000, 1.000, 1.000]
        
        var predict_means: [Double] = []
        var predict_variances: [Double] = []
        var update_means: [Double] = []
        var update_variances: [Double] = []

        // Perform Kalman filter on measurements z
        for z in zs {
            let prior = Gaussian.predict(lhs: x, rhs: process_model)
            let likehood = Gaussian(mean: z, variance: sensor_var)
            x = Gaussian.update(lhs: prior, rhs: likehood)
            
            predict_means.append(prior.mean)
            predict_variances.append(prior.variance)
            update_means.append(x.mean)
            update_variances.append(x.variance)
        }
        
        _ = zip(predict_means, expected_predict_means).map { XCTAssertEqual($0, $1, accuracy: 0.01) }
        _ = zip(predict_variances, expected_predict_variances).map { XCTAssertEqual($0, $1, accuracy: 0.01) }
        _ = zip(update_means, expected_update_means).map { XCTAssertEqual($0, $1, accuracy: 0.01) }
        _ = zip(update_variances, expected_update_variances).map { XCTAssertEqual($0, $1, accuracy: 0.01) }

        XCTAssertEqual(x.mean, 15.053, accuracy: 0.01)
    }

}
