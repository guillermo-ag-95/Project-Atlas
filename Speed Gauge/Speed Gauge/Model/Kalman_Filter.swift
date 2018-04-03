//
//  Kalman_Filter.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 3/4/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation
import Surge

class Kalman_Filter {
    
    /** Kalman Filter Algorithm:
    
     Initialization:
     1. Initialize the state of the filter.
     2. Initialize our belief in the state.
     
     Predict:
     1. Use process model to predict state at the next time step.
     2. Adjust belief to account for the uncertainty in prediction.
     
     Update:
     1. Get a measurement and associated belief about its accuracy.
     2. Compute residual between estimated state and measurement
     3. Compute scaling factor based on whether the measurement or prediction is more accurate
     4. Set state between the prediction and measurement based on scaling factor
     5. Update belief in the state based on how certain we are in the measurement
     
     */
    
    class func filter(){
        
        let dt: Double = 0.1 // Time step
        
        var x: Matrix<Double> // State variable
        var P: Matrix<Double> // State covariance
        
        var F: Matrix<Double> // Process model
        var Q: Matrix<Double> // Process noise
        
        var B: Matrix<Double> // Control input model
        var u: Matrix<Double> // Control input
        
        x = Matrix<Double>([[10.0],[4.5]])
        P = Matrix<Double>([[500, 0],[0, 49]])
        F = Matrix<Double>([[1, dt],[0, 1]])
        Q = Matrix<Double>([[0.588, 1.175], [1.175, 2.35]]) // This calculation will be explained later
        B = Matrix<Double>(rows: F.rows, columns: F.columns, repeatedValue: 0)
        u = Matrix<Double>(rows: x.rows, columns: x.columns, repeatedValue: 0)
        
        let (x_prior, P_prior) = Kalman_Filter.predict(x, P, F, Q, B, u)
        print(x_prior, P_prior)
        
        var z: Matrix<Double> // Measurement
        var H: Matrix<Double> // Measurement function
        var R: Matrix<Double> // Measurement noise
        
        z = Matrix<Double>([[1]])
        H = Matrix<Double>([[1,0]])
        R = Matrix<Double>([[5]])
        
        (x, P) = Kalman_Filter.update(x_prior, P_prior, z, R, H)
        print(x, P)
        
    }
    
    class func predict(_ x: Matrix<Double>, _ P: Matrix<Double>, _ F: Matrix<Double>, _ Q: Matrix<Double>, _ B: Matrix<Double>, _ u: Matrix<Double>) -> (Matrix<Double>, Matrix<Double>) {
        let x_prior = F * x + B * u
        let P_prior = F * P * Surge.transpose(F) + Q
        return (x_prior, P_prior)
    }
    
    class func update(_ x_prior: Matrix<Double>, _ P_prior: Matrix<Double>, _ z: Matrix<Double>, _ R: Matrix<Double>, _ H: Matrix<Double>) -> (Matrix<Double>, Matrix<Double>){
        let y = z + (-1) * H * x_prior
        let K = P_prior * Surge.transpose(H) * Surge.inv((H * P_prior * Surge.transpose(H) + R))
        let x = x_prior + K * y
        let P = (P_prior * Surge.inv(P_prior) + (-1) * K * H) * P_prior
        return (x, P)
    }
    
}
