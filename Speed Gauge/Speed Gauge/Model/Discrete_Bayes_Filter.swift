//
//  Discrete_Bayes_Filter.swift
//  Speed Gauge
//
//  Created by Guillermo Alcalá Gamero on 1/4/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation
import Surge

class Discrete_Bayes_Filter {
    
    func update_belief(hall: [Int], belief: [Double], z: Int, z_prob: Double) -> [Double] {
        var belief = belief
        let scale = z_prob / (1 - z_prob)

        for (i, val) in hall.enumerated() {
            if (val == z){
                belief[i] *= scale
            }
        }
        
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
		let posterior = likehood .* prior
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
    
    func perfect_predict(belief: [Double], move: Int) -> [Double]{
        let n = belief.count
        var result = Array(repeating: 0.0, count: n)
        
        for i in 0..<n {
            result[i] = belief[(n+i-move) % n]
        }
        
        return result
        
    }
    
    func predict_move(belief: [Double], move: Int, p_under: Double, p_correct: Double, p_over: Double) -> [Double]{
        let n = belief.count
        var prior = Array(repeating: 0.0, count: n)
        
        for i in 0..<n {
            prior[i] = (belief[(n+i-move) % n] * p_correct + belief[(n+i-move-1) % n] * p_over + belief[(n+i-move+1) % n] * p_under)
        }
        return prior
    }
    
    func predict_move_convolution(probability_distribution: [Double], offset: Int, kernel: [Double]) -> [Double]{
        let n = probability_distribution.count
        let kn = kernel.count
        let width = (kn - 1) / 2
        
        var prior = Array(repeating: 0.0, count: n)
        
        for i in 0..<n {
            for k in 0..<kn {
                let index = (n + i + (width-k) - offset) % n
                prior[i] += probability_distribution[index] * kernel[k]
            }
        }
        
        return prior
    }
    
}
