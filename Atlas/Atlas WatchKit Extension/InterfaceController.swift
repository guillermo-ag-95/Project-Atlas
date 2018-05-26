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
    
    var verticalAcceleration: [Double] = []                     // Array of vertical accelerations.
    var verticalVelocity: [Double] = []                         // Array of vertical velocities.
    var verticalFixedVelocity: [Double] = []                    // Array of vertical velocities after the data treatment.
    
    let queue: OperationQueue = OperationQueue()                // OperationQueue to execute the accelerometer updates.
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
        guard (motionManager?.isDeviceMotionAvailable)! else { return }
        
        initializeStoredData()
        
        motionManager?.startDeviceMotionUpdates(to: queue, withHandler: { (data, error) in
            if let data = data{
                self.updateStoredData(data)
            }
        })
    }
    
    @objc func stopRecordData(){
        motionManager?.deviceMotionUpdateInterval = updateIntervalOff
        guard (motionManager?.isDeviceMotionAvailable)! else { return }
        motionManager?.stopDeviceMotionUpdates()
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
    
    func initializeStoredData(){
        // Clear data arrays.
        verticalAcceleration.removeAll()
        verticalVelocity.removeAll()
        verticalFixedVelocity.removeAll()
        
        // Add zeros to let the integration work
        verticalAcceleration.append(0)
        verticalVelocity.append(0)
    }
    
    func updateStoredData(_ data: CMDeviceMotion){
        // Retrieve the accelerometer data from the sensor.
        let newXAcceleration = data.userAcceleration.x
        let newYAcceleration = data.userAcceleration.y
        let newZAcceleration = data.userAcceleration.z
        
        // Retrieve the gravity data from the sensor.
        let newXGravity = data.gravity.x
        let newYGravity = data.gravity.y
        let newZGravity = data.gravity.z
        
        // Compute scalar projection of the acceleration vector onto the gravity vector.
        let gravityModule = sqrt(pow(newXGravity, 2) + pow(newYGravity, 2) + pow(newZGravity, 2))
        let accelerometerData = [newXAcceleration, newYAcceleration, newZAcceleration]
        let gravityData = [newXGravity, newYGravity, newZGravity]
        let scalarProjection = 0.0 // TODO
        
        // Compute vertical acceleration and velocity.
        let newVerticalAcceleration = 0.0 // TODO
        let newVerticalVelocity = (verticalAcceleration.last! * updateIntervalOn) + (newVerticalAcceleration - verticalAcceleration.last!) * (updateIntervalOn / 2)
        let currentVerticalVelocity = verticalVelocity.last! + newVerticalVelocity
        
        // Data storage.
        verticalAcceleration.append(newVerticalAcceleration)
        verticalVelocity.append(currentVerticalVelocity)
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
// Compute scalar projection of the acceleration vector onto the gravity vector
