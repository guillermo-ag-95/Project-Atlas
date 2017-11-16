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
        view.addSubview(playPauseButton)
        
        // Let introduce AutoLayout Code.
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        playPauseButtonConstraints()
        
        super.updateViewConstraints()
    }
    
    @IBAction func playPauseButtonPressed(){
        
    }
    
    lazy var playPauseButton: UIButton! = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        view.setImage(#imageLiteral(resourceName: "pause"), for: .highlighted) // TODO
        view.addTarget(self, action: #selector(MainViewController.playPauseButtonPressed), for: .touchDown)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    func playPauseButtonConstraints(){
        // The button is centered.
        NSLayoutConstraint(
            item: playPauseButton,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0
        ).isActive = true
        
        // The bottom of the button is the 90% of the height of the view.
        NSLayoutConstraint(
            item: playPauseButton,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 0.9,
            constant: 0.0
        ).isActive = true
        
        // The width of the button is the 20% of the width of the view.
        NSLayoutConstraint(
            item: playPauseButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: view.bounds.size.width * 0.2
        ).isActive = true
        
        // The height of the button is the same as its width.
        NSLayoutConstraint(
            item: playPauseButton,
            attribute: .height,
            relatedBy: .equal,
            toItem: playPauseButton,
            attribute: .width,
            multiplier: 1.0,
            constant: 0.0
        ).isActive = true
        
    }

}
