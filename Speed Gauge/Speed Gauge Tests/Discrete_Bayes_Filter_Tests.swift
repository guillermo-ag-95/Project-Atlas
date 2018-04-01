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
        
        let expected = [0.30000000000000004, 0.30000000000000004, 0.10000000000000001, 0.10000000000000001, 0.10000000000000001, 0.10000000000000001, 0.10000000000000001, 0.10000000000000001, 0.30000000000000004, 0.10000000000000001]
        let posterior = discrete_Bayes_Filter.update_belief(hall: hallway, belief: belief, z: reading, z_prob: 0.75)
        
        XCTAssert(expected == posterior)
    }
    
    /// Updating belief with normalization.
    func test_update_belief_2(){
        let belief = Array(repeating: 0.1, count: 10)
        let hallway = [1, 1, 0, 0, 0, 0, 0, 0, 1, 0]
        let reading = 1 // '1' is a door.
        
        let expected = [0.18750000000000003, 0.18750000000000003, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.18750000000000003, 0.0625]
        var posterior = discrete_Bayes_Filter.update_belief(hall: hallway, belief: belief, z: reading, z_prob: 0.75)
        posterior = discrete_Bayes_Filter.normalize(data: posterior)
        
        XCTAssert(expected == posterior)
    }
    
    /// Scaling update (normalization included).
    func test_scaled_update_1(){
        let belief = Array(repeating: 0.1, count: 10)
        let hallway = [1, 1, 0, 0, 0, 0, 0, 0, 1, 0]
        let reading = 1 // '1' is a door.
        
        let expected = [0.18750000000000003, 0.18750000000000003, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.18750000000000003, 0.0625]
        let posterior = discrete_Bayes_Filter.scaled_update(hall: hallway, belief: belief, z: reading, z_prob: 0.75)
        
        XCTAssert(expected == posterior)
    }
    
    /// Updating with likehood.
    func test_lh_hallway_and_update_1(){
        let belief = Array(repeating: 0.1, count: 10)
        let hallway = [1, 1, 0, 0, 0, 0, 0, 0, 1, 0]
        let reading = 1 // '1' is a door.
        
        let expected = [0.18750000000000003, 0.18750000000000003, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.18750000000000003, 0.0625]

        let likehood = discrete_Bayes_Filter.lh_hallway(hall: hallway, z: reading, z_prob: 0.75)
        let posterior = discrete_Bayes_Filter.update(likehood: likehood, prior: belief)
        
        XCTAssert(expected == posterior)
    }
    
    /// Perfect prediction with a right shift.
    func test_perfect_predict_1(){
        let belief = [0.35, 0.1, 0.2, 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05]
        
        let expected = [0.050000000000000003, 0.34999999999999998, 0.10000000000000001, 0.20000000000000001, 0.29999999999999999, 0.0, 0.0, 0.0, 0.0, 0.0]
        let posterior = discrete_Bayes_Filter.perfect_predict(belief: belief, move: 1)
        
        XCTAssert(expected == posterior)
    }
    
    /// Predict move.
    func test_predict_move_1(){
        let belief = [0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        let expected = [0.0, 0.0, 0.0, 0.10000000000000001, 0.80000000000000004, 0.10000000000000001, 0.0, 0.0, 0.0, 0.0]
        let prior = discrete_Bayes_Filter.predict_move(belief: belief, move: 1, p_under: 0.1, p_correct: 0.8, p_over: 0.1)
        
        XCTAssert(expected == prior)
    }
    
    /// Predict move with some uncertainty.
    func test_predict_move_2(){
        let belief = [0.0, 0.0, 0.4, 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        let expected = [0.0, 0.0, 0.0, 0.040000000000000008, 0.38000000000000006, 0.52000000000000002, 0.059999999999999998, 0.0, 0.0, 0.0]
        let prior = discrete_Bayes_Filter.predict_move(belief: belief, move: 2, p_under: 0.1, p_correct: 0.8, p_over: 0.1)
        
        XCTAssert(expected == prior)
    }
    
    /// Predict move with convolution.
    func test_predict_move_convolution(){
        let belief = [0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        let expected = [0.0, 0.0, 0.0, 0.10000000000000001, 0.80000000000000004, 0.10000000000000001, 0.0, 0.0, 0.0, 0.0]
        let prior = discrete_Bayes_Filter.predict_move_convolution(probability_distribution: belief, offset: 1, kernel: [0.1, 0.8, 0.1])
        
        XCTAssert(expected == prior)
    }
    
    ///
    func test_integrating_measurements_and_movement_updates(){
        let hallway = [1, 1, 0, 0, 0, 0, 0, 0, 1, 0]
        var prior = Array(repeating: 0.1, count: 10)
        var likehood = discrete_Bayes_Filter.lh_hallway(hall: hallway, z: 1, z_prob: 0.75)
        
        var posterior = discrete_Bayes_Filter.update(likehood: likehood, prior: prior)
        var expected = [0.18750000000000003, 0.18750000000000003, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.18750000000000003, 0.0625]
        
        XCTAssert(expected == posterior)
        
        let kernel = [0.1, 0.8, 0.1]
        
        prior = discrete_Bayes_Filter.predict_move_convolution(probability_distribution: posterior, offset: 1, kernel: kernel)
        expected = [0.087500000000000008, 0.17500000000000002, 0.17500000000000004, 0.075000000000000011, 0.0625, 0.0625, 0.0625, 0.0625, 0.075000000000000011, 0.16250000000000003]

        XCTAssert(expected == prior)
        
        likehood = discrete_Bayes_Filter.lh_hallway(hall: hallway, z: 1, z_prob: 0.75)
        
        posterior = discrete_Bayes_Filter.update(likehood: likehood, prior: prior)
        expected = [0.15671641791044774, 0.31343283582089548, 0.10447761194029852, 0.044776119402985072, 0.037313432835820892, 0.037313432835820892, 0.037313432835820892, 0.037313432835820892, 0.13432835820895522, 0.097014925373134331]
        
        XCTAssert(expected == posterior)
        
        prior = discrete_Bayes_Filter.predict_move_convolution(probability_distribution: posterior, offset: 1, kernel: kernel)
        expected = [0.10671641791044777, 0.16641791044776116, 0.27686567164179104, 0.11940298507462688, 0.050000000000000003, 0.038059701492537311, 0.037313432835820892, 0.037313432835820892, 0.047014925373134328, 0.1208955223880597]
        
        XCTAssert(expected == prior)

        likehood = discrete_Bayes_Filter.lh_hallway(hall: hallway, z: 0, z_prob: 0.75)
        posterior = discrete_Bayes_Filter.update(likehood: likehood, prior: prior)
        expected = [0.045224541429475018, 0.070524984187223264, 0.35199240986717267, 0.15180265654648958, 0.063567362428842519, 0.04838709677419354, 0.047438330170777983, 0.047438330170777983, 0.019924098671726755, 0.1537001897533207]
        
        XCTAssert(expected == posterior)

        prior = discrete_Bayes_Filter.predict_move_convolution(probability_distribution: posterior, offset: 1, kernel: kernel)
        expected = [0.12947501581277673, 0.058602150537634415, 0.09614168247944338, 0.30382669196710949, 0.16299810246679319, 0.070872865275142333, 0.049810246679316883, 0.047533206831119543, 0.044686907020872864, 0.036053130929791274]
        
        XCTAssert(expected == prior)

        likehood = discrete_Bayes_Filter.lh_hallway(hall: hallway, z: 0, z_prob: 0.75)
        posterior = discrete_Bayes_Filter.update(likehood: likehood, prior: prior)
        expected = [0.051085600199650617, 0.023122036436236591, 0.11380084851509857, 0.35963314200149749, 0.19293735962066388, 0.083890691290242111, 0.058959321187921139, 0.056264037933616173, 0.017631644621911656, 0.042675318193161976]
        
        XCTAssert(expected == posterior)

    }


}
