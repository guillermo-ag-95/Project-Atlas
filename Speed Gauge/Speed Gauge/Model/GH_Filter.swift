//
//  G_H_Filter.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 31/3/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation
import Surge

class GH_Filter: Filter {
    
    /**
     - parameters:
        - data: The data to be filtered.
        - initial_guess: Starting value we know is correct for sure.
        - scale_factor: Indicates if we prefer the prediction (close to 0) or the measurement (close to 1).
        - gain_rate: Indicates the data rate of change.
        - time_step: Indicates the relationship between the gain_rate and the time spam between the data.
     - returns: Data filtered.
     - complexity: O(n) where n is the number of elements in data.
     */
    func predict_using_gain_guess_batch(_ data: [Double], initial_guess: Double, scale_factor: Double, gain_rate: Double, time_step: Double) -> [Double] {
        // Store the filtered results
        var estimates: [Double] = [initial_guess]
        var predictions: [Double] = []
        
        // Most filter literature uses 'z' for measurements
        for z in data {
            // Predict new position
            let prediction = estimates.last! + gain_rate * time_step
            
            // Update filter
            let estimate = prediction + scale_factor * (z - prediction)
            
            // Save
            estimates.append(estimate)
            predictions.append(prediction)
        }
        
        // initial_guess is not a filtered data.
        estimates.remove(at: 0)
        
        return estimates
    }
    
    /**
     - parameters:
     - data: The data to be filtered.
     - initial_guess: Starting data value we know is correct for sure.
     - scale_factor: Indicates if we prefer the prediction (close to 0) or the measurement (close to 1).
     - initial_gain_rate: Starting gain value we know is correct for sure.
     - scale_gain: Indicates if we prefer the given gain (close to 0) or the adjusted one (close to 1).
     - time_step: Indicates the relationship between the gain_rate and the time spam between the data.
     - returns: Data filtered.
     - complexity: O(n) where n is the number of elements in data.
     */
    func predict_using_adaptative_gain_batch(_ data: [Double], initial_guess: Double, scale_factor: Double, initial_gain_rate: Double, scale_gain: Double, time_step: Double) -> [Double] {
        // Store the filtered results
        var estimates: [Double] = [initial_guess]
        var predictions: [Double] = []
        
        var gain_rate: Double = initial_gain_rate
        
        // Most filter literature uses 'z' for measurements
        for z in data {
            // Prediction step
            let prediction = estimates.last! + gain_rate * time_step
            predictions.append(prediction)
            
            // Update step
            let residual = z - prediction
            
            gain_rate = gain_rate + scale_gain * (residual/time_step)
            let estimate = prediction + scale_factor * residual
            estimates.append(estimate)
            
        }
        
        // initial_guess is not a filtered data.
        estimates.remove(at: 0)
        
        return estimates
        
        
        
    }
    
}
