//
//  ExampleViewController.swift
//  iPhone Accelerometer Gauge
//
//  Created by Guillermo Alcalá Gamero on 14/11/17.
//  Copyright © 2017 Guillermo Alcalá Gamero. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This lets the application sknow where to look for the implementation of the delegate methods.
        // In this case is inside Self, a reference to our MainViewController class.
        textField.delegate = self

        view.addSubview(textField) // Add the textField to the view.
        view.addSubview(button) // Add the button to the view.
        view.addSubview(label) // Add the label to the view.
        view.setNeedsUpdateConstraints() // Let us introduce AutoLayout code.
    }
    
    @IBAction func buttonPressed(){
        label.text = "Hello, \(textField.text!)"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard by making the text field resign first responder.
        return false // Instead of adding a line break, the text field resigns.
    }
    
    override func updateViewConstraints() {
        textFieldConstraints()
        buttonConstraints()
        labelConstraints()
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
    
    lazy var button: UIButton! = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(ExampleViewController.buttonPressed), for: .touchDown) // Let's specify an action when the button is pressed.
        view.setTitle("Press Me!", for: .normal)
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    func buttonConstraints(){
        // Center the button in page view.
        NSLayoutConstraint(
            item: button,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0
        ).isActive = true
        
        // Set Width to 30% of the page view width.
        NSLayoutConstraint(
            item: button,
            attribute: .width,
            relatedBy: .equal,
            toItem: view,
            attribute: .width,
            multiplier: 0.3,
            constant: 0.0
        ).isActive = true
        
        // Set Y position relative to bottom of page view.
        NSLayoutConstraint(
            item: button,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 0.9,
            constant: 0.0
        ).isActive = true
    }
    
    lazy var label: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Hello World!"
        view.textAlignment = .center
        return view
    }()
    
    func labelConstraints(){
        // Center label to page view.
        NSLayoutConstraint(
            item: label,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0
        ).isActive = true
        
        // Set width to be 80% of the page view width.
        NSLayoutConstraint(
            item: label,
            attribute: .width,
            relatedBy: .equal,
            toItem: view,
            attribute: .width,
            multiplier: 0.8,
            constant: 0.0
        ).isActive = true
        
        // Set Y position relative to bottom of page view.
        NSLayoutConstraint(
            item: label,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0
        ).isActive = true
    }

}
