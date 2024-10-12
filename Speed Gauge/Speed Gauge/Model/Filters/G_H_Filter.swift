//
//  G_H_Filter.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 31/3/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation
import Surge

class G_H_Filter {
    
    var x0: Double  // The initial value of the state variable.
    var dx: Double  // The initial change rate for our state variable.
    let g: Double   // Scaling factor of the measurement.
    let h: Double   // Scaling factor of the change of the measurement.
    let dt: Double  // Lenght of the time step.
    
    /**
     - parameters:
        - x0: The initial value of the state variable.
        - dx: The initial change rate for our state variable.
        - g: Scaling factor of the measurement.
        - h: Scaling factor of the change of the measurement.
        - dt: Lenght of the time step.
     */
    init(x0: Double, dx: Double, g: Double, h: Double, dt: Double) {
        self.x0 = x0
        self.dx = dx
        self.g = g
        self.h = h
        self.dt = dt
    }
    
    /**
     - parameters:
        - z: Given sensor measurement.
     - returns: Filtered measurement.
     - complexity: O(1)
     */
    func filter(_ z: Double) -> Double {
        var x_est: Double = self.x0
        var dx: Double = self.dx
        
        // Prediction step
        let x_pred = x_est + (dx * self.dt)
        
        // Update step
        let residual = z - x_pred
        dx = dx + self.h * (residual / self.dt)
        x_est = x_pred + self.g * residual
        
        // Update filter
        self.x0 = x_est
        self.dx = dx
        
        return x_est
    }
    
    /**
     - parameters:
        - data: The data to be filtered.
     - returns: Filtered data.
     - complexity: O(n) where n is the number of measurements.
     */
    func filter(_ data: [Double]) -> [Double] {
        var x_est: Double
        var result: [Double] = []
        
        for z in data {
            x_est = self.filter(z)
            result.append(x_est)
        }
        
        return result
    }
    
    /**
     - parameters:
            - x0: The initial value of the noisy measurements.
            - dx: The initial change rate of the noisy measurements.
            - noise_factor:
     - returns: Noisy data.
     - complexity: O(n) where n is count.
     */
    class func gen_data(x0: Double, dx: Double, count: Int, noise_factor: Double) -> [Double] {
        var result: [Double] = []
        let data = x0
        
        for i in 0..<count {
            let data = data + dx * Double(i) + (Double(arc4random()) / Double(UInt32.max)) * noise_factor
            result.append(data)
        }
                
        return result
    }
    
}
