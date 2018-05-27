//
//  InterfaceController.swift
//  Atlas WatchKit Extension
//
//  Created by Guillermo Alcalá Gamero on 24/5/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import AVFoundation
import CoreMotion
import Foundation
import HealthKit
import WatchKit


class InterfaceController: WKInterfaceController {

    @IBOutlet var timePicker: WKInterfacePicker!
    @IBOutlet var playButton: WKInterfaceButton!
    @IBOutlet var pauseButton: WKInterfaceButton!
    
    var audioPlayer: AVAudioPlayer?                             // Audio player that will play the starting sound.
    var buttonTimesPressed: Int = 0                             // Counter to track which button is displayed
    var buttonVisibility: Bool = true                           // Boolean to alternate between play and pause button.
    var delay: Int = 0                                          // Delay to start the accelerometer measurements.
    var motionManager: CMMotionManager?                         // Motion Manager that will retrieve the accelerometer information.
    var timerCount: Timer?                                      // Timer that will delay the start of the accelerometer measures.
    var timerAccelerometer: Timer?                              // Timer that will delay the start of the accelerometer measures.

    var maxVelocities: [Double] = []                            // Array with the max velocity of every rep.
    var meanVelocities: [Double] = []                           // Array with the mean velocity of every rep.
    var verticalAcceleration: [Double] = []                     // Array of vertical accelerations.
    var verticalVelocity: [Double] = []                         // Array of vertical velocities.
    var verticalFixedVelocity: [Double] = []                    // Array of vertical velocities after the data treatment.
    
    let gravity = 9.81                                          // Gravity conversion from G to m/s.
    let queue: OperationQueue = OperationQueue()                // OperationQueue to execute the accelerometer updates.
    let times: [Int] = [0,1,3,5,7,10,12,15,17,20,23,25,30]      // Array of possible delays to choose from.
    let updateIntervalOn = 0.01                                 // Update interval of 0.01 seconds (100 Hz)
    let updateIntervalOff = 0.1                                 // Update interval of 0.1 seconds (10 Hz)
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configurate the screen to be turn on.
        
        // Configure buttons.
        playButton.setHidden(false)
        pauseButton.setHidden(true)
        
        // Configure time picker.
        timePicker.setItems(initializePicker(times))
        
        // Configure timers.
        timerCount = Timer.init()
        timerAccelerometer = Timer.init()

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
            timerCount?.invalidate()
            timerAccelerometer?.invalidate()
            timerCount = Timer.scheduledTimer(timeInterval: Double(delay), target: self, selector: #selector(self.playSound), userInfo: nil, repeats: false)
            timerAccelerometer = Timer.scheduledTimer(timeInterval: Double(delay), target: self, selector: #selector(self.startRecordData), userInfo: nil, repeats: false)
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
        
        self.treatStoredData()
        
        let data = [maxVelocities, meanVelocities]
        pushController(withName: "ResultInterfaceController", context: data)
    }
    
    @IBAction func chooseDelay(_ value: Int) {
        delay = times[value]
    }
    
    // Support functions:
    
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
        let accelerationVector = [newXAcceleration, newYAcceleration, newZAcceleration]
        let gravityVector = [newXGravity, newYGravity, newZGravity]
        let dotProduct = dot(gravityVector, accelerationVector)
        let scalarProjection = gravityVector.map { dotProduct / pow(gravityModule, 2) * $0 * self.gravity }
        
        // Compute vertical acceleration and velocity.
        let newVerticalAcceleration = sign(dotProduct) * sqrt(pow(scalarProjection[0], 2) + pow(scalarProjection[1], 2) + pow(scalarProjection[2], 2))
        let newVerticalVelocity = (verticalAcceleration.last! * updateIntervalOn) + (newVerticalAcceleration - verticalAcceleration.last!) * (updateIntervalOn / 2)
        let currentVerticalVelocity = verticalVelocity.last! + newVerticalVelocity
        
        // Data storage.
        verticalAcceleration.append(newVerticalAcceleration)
        verticalVelocity.append(currentVerticalVelocity)
    }
    
    func treatStoredData(){
        let slope = verticalVelocity.last! / Double(verticalVelocity.count)
        
        // Remove lineally the slope from the vertical acceleration.
        verticalFixedVelocity = verticalVelocity.enumerated().map({ (arg) -> Double in
            let (index, element) = arg
            return element - slope * Double(index)
        })
        
        // Calculate when the rep starts, ends,  max velocity and mean velocity.
        var maximum = 0.0
        var startingPoints: [Int] = []
        var endingPoints: [Int] = []
        
        maxVelocities = []
        meanVelocities = []
        
        for i in 0..<verticalFixedVelocity.count {
            let element = abs(verticalFixedVelocity[i]) < 0.1 ? 0.0 : verticalFixedVelocity[i]
            
            if element > 0.0 && maximum == 0.0 { startingPoints.append(i) }     // Save the starting point of the rep.
            if element > 0.0 && element > maximum { maximum = element }         // Update the maximum velocity if needed.
            
            if element == 0.0 && maximum != 0.0 {
                endingPoints.append(i)  // Save the ending point.
                
                // Check that the interval is big enough
                if (endingPoints.last! - startingPoints.last! < 30) {
                    // If not,
                    startingPoints.removeLast()
                    endingPoints.removeLast()
                    maximum = 0.0
                } else {
                    // If so, go on
                    maxVelocities.append(maximum)   // Save the max velocity of the rep.
                    maximum = 0.0                   // Reset the maximum velocity.
                    
                    let repVelocities = verticalFixedVelocity.suffix(from: startingPoints.last!).prefix(upTo: endingPoints.last!)
                    let meanVelocity = mean(Array(repVelocities))
                    
                    meanVelocities.append(meanVelocity)
                }
            }
        }
    }
    
    // Math functions
    
    func dot(_ x: [Double], _ y: [Double]) -> Double {
        assert(x.count == y.count, "Both vectors must be the same size")
        
        var result = 0.0
        
        for i in 0..<x.count {
            result = result + x[i] * y[i]
        }
        return result
    }
    
    func mean(_ x: [Double]) -> Double {
        var result = 0.0
        
        result = x.reduce(0.0, +)
        result = result / Double(x.count)
        
        return result
    }
    
    // Ancillary functions:
    
    @objc func playSound(){
        do {
            let path = Bundle.main.path(forResource: "Air Horn Sound.mp3", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            // Couldn't load file
            print("Couldn't load file")
        }
    }
    
}
