//
//  InterfaceController.swift
//  Atlas WatchKit Extension
//
//  Created by Guillermo Alcalá Gamero on 24/5/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var timePicker: WKInterfacePicker!
    @IBOutlet var playButton: WKInterfaceButton!
    @IBOutlet var pauseButton: WKInterfaceButton!
    
    let times: [Int] = [0,1,3,5,7,10,12,15,17,20,23,25,30]      // Array of possible delays to choose from.
    var buttonVisibility: Bool = true                           // Boolean to alternate between play and pause button.
    var buttonTimesPressed: Int = 0                             // Counter to track which button is displayed
    var delay: Int = 0                                          // Delay to start the accelerometer measurements.
    var timer : Timer = Timer.init();
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure buttons.
        playButton.setHidden(false)
        pauseButton.setHidden(true)
        
        // Configure time picker.
        timePicker.setItems(initializePicker(times))
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func playPauseButtonPressed() {
        // Change the visibility of the button.
        playButton.setHidden(buttonVisibility)
        pauseButton.setHidden(!buttonVisibility)
        buttonVisibility = !buttonVisibility
        buttonTimesPressed = buttonTimesPressed + 1
        
        // Print delay
        guard buttonTimesPressed % 2 == 1 else { return }
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: Double(delay), target: self, selector: #selector(self.playSound), userInfo: nil, repeats: false)

    }
    
    @IBAction func chooseDelay(_ value: Int) {
        delay = times[value]
    }
    
    // Ancillary functions:
    
    func initializePicker(_ times: [Int]) -> [WKPickerItem] {
        var timePickerItems: [WKPickerItem] = []
        
        for time in times {
            let timePickerItem = WKPickerItem()
            
            timePickerItem.title = "\(time) seconds"
            timePickerItems.append(timePickerItem)
        }
        
        return timePickerItems
    }
    
    @objc func playSound(){
        print(delay)
    }
    
}
