//
//  MainViewController.swift
//  iPhone Accelerometer Gauge
//
//  Created by Guillermo Alcalá Gamero on 14/11/17.
//  Copyright © 2017 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This lets the application sknow where to look for the implementation of the delegate methods.
        // In this case is inside Self, a reference to our MainViewController class.
        textField.delegate = self

        view.addSubview(textField) // Add the textField to the view.
        view.setNeedsUpdateConstraints() // Let us introduce AutoLayout code.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard by making the text field resign first responder.
        return false // Instead of adding a line break, the text field resigns.
    }
    
    override func updateViewConstraints() {
        textFieldConstraints()
        super.updateViewConstraints()
    }
    
    lazy var textField: UITextField! = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false // Let us set our custom constraints to the text field.
        view.borderStyle = .roundedRect
        view.textAlignment = .center
        
        return view
    }()
    
    func textFieldConstraints(){
        // Center Text Field relative to page view.
        NSLayoutConstraint(
            item: textField,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0
        ).isActive = true
        
        // Set Text Field width to 80% of the width of the page view.
        NSLayoutConstraint(
            item: textField,
            attribute: .width,
            relatedBy: .equal,
            toItem: view,
            attribute: .width,
            multiplier: 0.8,
            constant: 0.0
        ).isActive = true
        
        // Set Text Field Y position 10% down from the top of the page view.
        NSLayoutConstraint(
            item: textField,
            attribute: .top,
            relatedBy: .equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 0.1,
            constant: 0.0
        ).isActive = true
    }

}
