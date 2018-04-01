//
//  1D_Kalman_Filter.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 1/4/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation
import Surge

class One_Dimensional_Kalman_Filter: Filter {
    
}

class Gaussian {
    let mean, variance: Double
    
    init(mean: Double, variance: Double) {
        self.mean = mean
        self.variance = variance
    }
    
    class func predict(lhs: Gaussian, rhs: Gaussian) -> Gaussian {
        return Gaussian(mean: lhs.mean + rhs.mean, variance: lhs.variance + rhs.variance)
    }
    
    class func update(lhs: Gaussian, rhs: Gaussian) -> Gaussian {
        let mean = (lhs.variance * rhs.mean + rhs.variance * lhs.mean) / (lhs.variance + rhs.variance)
        let variance = (lhs.variance * rhs.variance) / (lhs.variance + rhs.variance)
        return Gaussian(mean: mean, variance: variance)
    }
    
}
