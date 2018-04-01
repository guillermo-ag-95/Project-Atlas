//
//  Discrete_Bayes_Filter_Tests.swift
//  Speed Gauge Tests
//
//  Created by Guillermo Alcalá Gamero on 1/4/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest
@testable import Speed_Gauge

class Discrete_Bayes_Filter_Tests: Abstract_Test {
    
    let discrete_Bayes_Filter = Discrete_Bayes_Filter()
    
    /// Updating belief without normalization.
    func test_update_belief_1(){
        let belief = Array(repeating: 0.1, count: 10)
        let hallway = [1, 1, 0, 0, 0, 0, 0, 0, 1, 0]
        let reading = 1 // '1' is a door.
        
        let expected = [0.3, 0.3, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.3, 0.1]
        let posterior = discrete_Bayes_Filter.update_belief(hall: hallway, belief: belief, z: reading, z_prob: 0.75)
        
        _ = zip(expected, posterior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }
        
    }
    
    /// Updating belief with normalization.
    func test_update_belief_2(){
        let belief = Array(repeating: 0.1, count: 10)
        let hallway = [1, 1, 0, 0, 0, 0, 0, 0, 1, 0]
        let reading = 1 // '1' is a door.
        
        let expected = [0.1875, 0.1875, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.1875, 0.0625]
        var posterior = discrete_Bayes_Filter.update_belief(hall: hallway, belief: belief, z: reading, z_prob: 0.75)
        posterior = discrete_Bayes_Filter.normalize(data: posterior)
        
        _ = zip(expected, posterior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }
        
    }
    
    /// Scaling update (normalization included).
    func test_scaled_update_1(){
        let belief = Array(repeating: 0.1, count: 10)
        let hallway = [1, 1, 0, 0, 0, 0, 0, 0, 1, 0]
        let reading = 1 // '1' is a door.
        
        let expected = [0.1875, 0.1875, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.1875, 0.0625]
        let posterior = discrete_Bayes_Filter.scaled_update(hall: hallway, belief: belief, z: reading, z_prob: 0.75)
        
        _ = zip(expected, posterior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }
    }
    
    /// Updating with likehood.
    func test_lh_hallway_and_update_1(){
        let belief = Array(repeating: 0.1, count: 10)
        let hallway = [1, 1, 0, 0, 0, 0, 0, 0, 1, 0]
        let reading = 1 // '1' is a door.
        
        let expected = [0.1875, 0.1875, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.1875, 0.0625]

        let likehood = discrete_Bayes_Filter.lh_hallway(hall: hallway, z: reading, z_prob: 0.75)
        let posterior = discrete_Bayes_Filter.update(likehood: likehood, prior: belief)
        
        _ = zip(expected, posterior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }
    }
    
    /// Perfect prediction with a right shift.
    func test_perfect_predict_1(){
        let belief = [0.35, 0.1, 0.2, 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05]
        
        let expected = [0.05, 0.35, 0.1, 0.2, 0.3, 0.0, 0.0, 0.0, 0.0, 0.0]
        let posterior = discrete_Bayes_Filter.perfect_predict(belief: belief, move: 1)
        
        _ = zip(expected, posterior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }
    }
    
    /// Predict move.
    func test_predict_move_1(){
        let belief = [0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        let expected = [0.0, 0.0, 0.0, 0.1, 0.8, 0.1, 0.0, 0.0, 0.0, 0.0]
        let prior = discrete_Bayes_Filter.predict_move(belief: belief, move: 1, p_under: 0.1, p_correct: 0.8, p_over: 0.1)
        
        _ = zip(expected, prior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }
    }
    
    /// Predict move with some uncertainty.
    func test_predict_move_2(){
        let belief = [0.0, 0.0, 0.4, 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        let expected = [0.0, 0.0, 0.0, 0.04, 0.38, 0.52, 0.06, 0.0, 0.0, 0.0]
        let prior = discrete_Bayes_Filter.predict_move(belief: belief, move: 2, p_under: 0.1, p_correct: 0.8, p_over: 0.1)
        
        _ = zip(expected, prior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }
    }
    
    /// Predict move with convolution.
    func test_predict_move_convolution(){
        let belief = [0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        let expected = [0.0, 0.0, 0.0, 0.1, 0.8, 0.1, 0.0, 0.0, 0.0, 0.0]
        let prior = discrete_Bayes_Filter.predict_move_convolution(probability_distribution: belief, offset: 1, kernel: [0.1, 0.8, 0.1])
        
        _ = zip(expected, prior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }
    }
    
    ///
    func test_integrating_measurements_and_movement_updates(){
        let hallway = [1, 1, 0, 0, 0, 0, 0, 0, 1, 0]
        var prior = Array(repeating: 0.1, count: 10)
        var likehood = discrete_Bayes_Filter.lh_hallway(hall: hallway, z: 1, z_prob: 0.75)
        
        var posterior = discrete_Bayes_Filter.update(likehood: likehood, prior: prior)
        var expected = [0.1875, 0.1875, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.1875, 0.0625]
        
        _ = zip(expected, posterior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }

        let kernel = [0.1, 0.8, 0.1]
        
        prior = discrete_Bayes_Filter.predict_move_convolution(probability_distribution: posterior, offset: 1, kernel: kernel)
        expected = [0.0875, 0.175, 0.175, 0.075, 0.0625, 0.0625, 0.0625, 0.0625, 0.075, 0.1625]

        _ = zip(expected, prior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }

        likehood = discrete_Bayes_Filter.lh_hallway(hall: hallway, z: 1, z_prob: 0.75)
        
        posterior = discrete_Bayes_Filter.update(likehood: likehood, prior: prior)
        expected = [0.1567, 0.3134, 0.1045, 0.04478, 0.0373, 0.0373, 0.0373, 0.0373, 0.1343, 0.0970]
        
        _ = zip(expected, posterior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }

        prior = discrete_Bayes_Filter.predict_move_convolution(probability_distribution: posterior, offset: 1, kernel: kernel)
        expected = [0.1067, 0.1664, 0.2769, 0.1194, 0.05, 0.038, 0.0373, 0.0373, 0.047, 0.1209]
        
        _ = zip(expected, prior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }

        likehood = discrete_Bayes_Filter.lh_hallway(hall: hallway, z: 0, z_prob: 0.75)
        posterior = discrete_Bayes_Filter.update(likehood: likehood, prior: prior)
        expected = [0.0452, 0.0705, 0.3520, 0.1518, 0.0636, 0.0484, 0.0474, 0.0474, 0.0199, 0.1537]
        
        _ = zip(expected, posterior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }

        prior = discrete_Bayes_Filter.predict_move_convolution(probability_distribution: posterior, offset: 1, kernel: kernel)
        expected = [0.1294, 0.0586, 0.0961, 0.3038, 0.1630, 0.0709, 0.0498, 0.0475, 0.0447, 0.0361]
        
        _ = zip(expected, prior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }

        likehood = discrete_Bayes_Filter.lh_hallway(hall: hallway, z: 0, z_prob: 0.75)
        posterior = discrete_Bayes_Filter.update(likehood: likehood, prior: prior)
        expected = [0.0511, 0.0231, 0.1138, 0.3596, 0.1929, 0.0839, 0.059, 0.0563, 0.0176, 0.0427]
        
        _ = zip(expected, posterior).map { XCTAssertEqual($0, $1, accuracy: 0.1) }

    }


}
