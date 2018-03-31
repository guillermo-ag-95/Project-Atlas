//
//  G_H_Filter.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 31/3/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation
import Surge

class G_H_Filter: Filter {
    
    /**
     - parameters:
        - data: The data to be filtered.
        - x0: The initial value of the state variable
        - dx: The initial change rate for our state variable.
        - g: Scaling factor of the measurement.
        - h: Scaling factor of the change of the measurement.
        - dt: Lenght of the time step.
     - returns: Filtered data.
     - complexity: O(n) where n is the number of measurements.
     */
    func filter(_ data: [Double], x0: Double, dx: Double, g: Double, h: Double, dt: Double) -> [Double] {
        var x_est: Double = x0
        var dx: Double = dx
        var results: [Double] = []
        
        for z in data {
            // Prediction step
            let x_pred = x_est + (dx * dt)
            
            // Update step
            let residual = z - x_pred
            dx = dx + h * (residual / dt)
            x_est = x_pred + g * residual
            results.append(x_est)
        }
        
        return results
        
    }
    
}
