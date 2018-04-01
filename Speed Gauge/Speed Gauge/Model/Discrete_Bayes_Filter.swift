//
//  Discrete_Bayes_Filter.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 1/4/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation
import Surge

class Discrete_Bayes_Filter: Filter {
    
    func filter() -> [Double] {
        let result: [Double] = []
        
        let belief = Array(repeating: 0.1, count: 10)
        let hallway = [1, 1, 0, 0, 0, 0, 0, 0, 1, 0]
        let reading = 1 // '1' is a door
//        let posterior = update_belief(hall: hallway, belief: belief, z: reading, z_prob: 0.75)
//        let posterior = scaled_update(hall: hallway, belief: belief, z: reading, z_prob: 0.75)
        let likehood = lh_hallway(hall: hallway, z: reading, z_prob: 0.75)
        let posterior = update(likehood: likehood, prior: belief)
        
        print("Posterior: \(posterior)")
        print("Sum = \(Surge.sum(posterior))")
        
        return result
    }
    
    func update_belief(hall: [Int], belief: [Double], z: Int, z_prob: Double) -> [Double] {
        var belief = belief
        let scale = z_prob / (1 - z_prob)

        for (i, val) in hall.enumerated() {
            if (val == z){
                belief[i] *= scale
            }
        }
        
        belief = normalize(data: belief)
        
        return belief
    }
    
    func normalize(data: [Double]) -> [Double] {
        return data.map({ $0 / Surge.sum(data) })
    }
    
    func scaled_update (hall: [Int], belief: [Double], z: Int, z_prob: Double) -> [Double] {
        let scale = z_prob / (1 - z_prob)
        var likehood = Array(repeating: 1.0, count: hall.count)
        
        for (i, val) in hall.enumerated() {
            if (val == z){
                likehood[i] *= scale
            }
        }
        
        let posterior = normalize(likehood: likehood, prior: belief)
        
        return posterior
    }
    
    func normalize(likehood: [Double], prior: [Double]) -> [Double] {
        let posterior = Surge.mul(likehood, y: prior)
        return posterior.map({ $0 / Surge.sum(posterior) })
    }
    
    func lh_hallway(hall: [Int], z: Int, z_prob: Double) -> [Double] {
        let scale = z_prob / (1 - z_prob)
        var likehood = Array(repeating: 1.0, count: hall.count)
        
        for (i, val) in hall.enumerated() {
            if (val == z){
                likehood[i] *= scale
            }
        }
        
        return likehood
    }
    
    func update(likehood: [Double], prior: [Double]) -> [Double] {
        let posterior = normalize(likehood: likehood, prior: prior)
        return posterior
    }
    
}
