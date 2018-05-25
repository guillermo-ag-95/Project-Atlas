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

    @IBOutlet var playButton: WKInterfaceButton!
    @IBOutlet var pauseButton: WKInterfaceButton!
    
    var showPlayButton: Bool = true
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        playButton.setHidden(false)
        pauseButton.setHidden(true)
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
        playButton.setHidden(showPlayButton)
        pauseButton.setHidden(!showPlayButton)
        
        showPlayButton = !showPlayButton
    }
}
