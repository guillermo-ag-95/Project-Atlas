//
//  InterfaceController.swift
//  Atlas WatchKit Extension
//
//  Created by Guillermo Alcalá Gamero on 24/5/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import AVFoundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var timePicker: WKInterfacePicker!
    @IBOutlet var playButton: WKInterfaceButton!
    @IBOutlet var pauseButton: WKInterfaceButton!
    
    var audioPlayer: AVAudioPlayer?                             // Audio player that will play the starting sound.
    var buttonTimesPressed: Int = 0                             // Counter to track which button is displayed
    var buttonVisibility: Bool = true                           // Boolean to alternate between play and pause button.
    var delay: Int = 0                                          // Delay to start the accelerometer measurements.
    var motionManager: CMMotionManager?                         // Motion Manager that will retrieve the accelerometer information.
    var timer : Timer?                                          // Timer that will delay the start of the accelerometer measures.
    
    let times: [Int] = [0,1,3,5,7,10,12,15,17,20,23,25,30]      // Array of possible delays to choose from.
    let updateIntervalOn = 0.01                                 // Update interval of 0.01 seconds (100 Hz)
    let updateIntervalOff = 0.1                                 // Update interval of 0.1 seconds (10 Hz)
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure buttons.
        playButton.setHidden(false)
        pauseButton.setHidden(true)
        
        // Configure time picker.
        timePicker.setItems(initializePicker(times))
        
        // Configure timer.
        timer = Timer.init()
        
        // Configure audio player.
        audioPlayer = initializeAudioPlayer()
        
        // Configure motion manager.
        motionManager = CMMotionManager()
        
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
        
        // Only trigger the action after the play button is pressed.
        if buttonTimesPressed % 2 == 1 {
            // Delay the start of the accelerometer updates.
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: Double(delay), target: self, selector: #selector(self.playSound), userInfo: nil, repeats: false)
            timer = Timer.scheduledTimer(timeInterval: Double(delay), target: self, selector: #selector(self.startRecordData), userInfo: nil, repeats: false)
        } else {
            stopRecordData()
        }
        
    }
    
    @objc func startRecordData(){
        motionManager?.deviceMotionUpdateInterval = updateIntervalOn
    }
    
    @objc func stopRecordData(){
        motionManager?.deviceMotionUpdateInterval = updateIntervalOff
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
    
    func initializeAudioPlayer() -> AVAudioPlayer {
        let audioPlayer = AVAudioPlayer()
        return audioPlayer
    }
    
    @objc func playSound(){
        do {
            let path = Bundle.main.path(forResource: "Comedy Low Honk.caf", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            // Couldn't load file
            print("Couldn't load file")
        }
    }
    
}
