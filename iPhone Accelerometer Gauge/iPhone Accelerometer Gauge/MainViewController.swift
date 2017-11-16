//
//  MainViewController.swift
//  iPhone Accelerometer Gauge
//
//  Created by Guillermo Alcalá Gamero on 16/11/17.
//  Copyright © 2017 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add UI Elements to view
        initializeButtons()
        
        // Let introduce AutoLayout Code.
        view.setNeedsUpdateConstraints()
    }
    
    func initializeButtons(){
        playButton.isHidden = false
        pauseButton.isHidden = true
        
        view.addSubview(playButton)
        view.addSubview(pauseButton)
    }
    
    override func updateViewConstraints() {
        playPauseButtonConstraints(playButton)
        playPauseButtonConstraints(pauseButton)

        super.updateViewConstraints()
    }
    
    @IBAction func playPauseButtonPressed(){
        playButton.isHidden = !playButton.isHidden
        pauseButton.isHidden = !pauseButton.isHidden
    }
    
    lazy var playButton: UIButton! = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        view.addTarget(self, action: #selector(MainViewController.playPauseButtonPressed), for: .touchDown)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var pauseButton: UIButton! = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        view.addTarget(self, action: #selector(MainViewController.playPauseButtonPressed), for: .touchDown)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    func playPauseButtonConstraints(_ sender: UIButton){
        // The button is centered.
        NSLayoutConstraint(
            item: sender,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0
        ).isActive = true
        
        // The bottom of the button is the 90% of the height of the view.
        NSLayoutConstraint(
            item: sender,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 0.9,
            constant: 0.0
        ).isActive = true
        
        // The width of the button is the 20% of the width of the view.
        NSLayoutConstraint(
            item: sender,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: view.bounds.size.width * 0.2
        ).isActive = true
        
        // The height of the button is the same as its width.
        NSLayoutConstraint(
            item: sender,
            attribute: .height,
            relatedBy: .equal,
            toItem: sender,
            attribute: .width,
            multiplier: 1.0,
            constant: 0.0
        ).isActive = true
        
    }
    
    lazy var accelerationLabel: UILabel! = {
        let view = UILabel()
        view.text = "Acceleration"
        return view
    }()
    
    lazy var xAxisLabel: UILabel! = {
        let view = UILabel()
        view.text = "X Axis"
        return view
    }()
    
    lazy var yAxisLabel: UILabel! = {
        let view = UILabel()
        view.text = "Y Axis"
        return view
    }()
    
    lazy var zAxisLabel: UILabel! = {
        let view = UILabel()
        view.text = "Z Axis"
        return view
    }()

}
