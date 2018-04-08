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
    
    
    var x: Matrix<Double> // State variable mean.
    var P: Matrix<Double> // State variable covariance.
    
    var F: Matrix<Double> // Process model.
    var Q: Matrix<Double> // Process noise covariance.
    
    var B: Matrix<Double> // Control input model.
    var u: Matrix<Double> // Control input.
    
    var H: Matrix<Double> // Measurement function.
    var R: Matrix<Double> // Measurement noise covariance.
    
    /**
     - parameters:
        - x: State variable mean.
        - P: State variable covariance.
        - F: Process model.
        - Q: Process noise.
        - B: Control input model.
        - u: Control input.
        - H: Measurement function.
        - R: Measurement noise.
     */
    init(_ x: Matrix<Double>, _ P: Matrix<Double>, _ F: Matrix<Double>, _ Q: Matrix<Double>, _ B: Matrix<Double>, _ u: Matrix<Double>, _ H: Matrix<Double>, _ R: Matrix<Double>) {
        self.x = x
        self.P = P
        self.F = F
        self.Q = Q
        self.B = B
        self.u = u
        self.H = H
        self.R = R
    }
    
    /**
     - parameters:
        - z: A single measurement from the sensor.
     - returns: Filtered measurement and updated state covariance matrix.
     */
    func filter(_ z: Matrix<Double>) -> (x: Matrix<Double>, P: Matrix<Double>) {
        let (x_prior, P_prior) = self.predict()
        let (x, P) = self.update(x_prior, P_prior, z)
        return (x, P)
    }
    
    /**
     - returns: Predict state and belief for the next time step.
     */
    func predict() -> (x_prior: Matrix<Double>, P_prior: Matrix<Double>) {
        let x_prior = self.F * self.x + self.B * self.u
        let P_prior = self.F * self.P * Surge.transpose(self.F) + self.Q
        return (x_prior, P_prior)
    }
    
    /**
     - parameters:
        - x_prior: Prediction for the next time step.
        - P_prior: Updated belief to account for the uncertainty in prediction.
        - z: A single measurement from the sensor.
     - returns: Filtered measurement and updated state covariance matrix.
     */
    func update(_ x_prior: Matrix<Double>, _ P_prior: Matrix<Double>, _ z: Matrix<Double>) -> (x: Matrix<Double>, P: Matrix<Double>) {
        let y = z + (-1) * self.H * x_prior
        let K = P_prior * Surge.transpose(self.H) * Surge.inv((self.H * P_prior * Surge.transpose(self.H) + self.R))
        let x = x_prior + K * y
        let P = (P_prior * Surge.inv(P_prior) + (-1) * K * self.H) * P_prior
        
        self.x = x
        self.P = P
        
        return (x, P)

    }
    
}
