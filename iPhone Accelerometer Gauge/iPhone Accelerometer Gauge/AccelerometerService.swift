//
//  AccelerometerService.swift
//  iPhone Accelerometer Gauge
//
//  Created by Guillermo Alcalá Gamero on 27/11/17.
//  Copyright © 2017 Guillermo Alcalá Gamero. All rights reserved.
//

import Foundation

import CoreMotion
import AVFoundation

final class AccelerometerService {

    private init() {}
    
    // MARK: Shared Instance
    static let shared = AccelerometerService()
    
    // MARK: Local Properties
    var motionManager = CMMotionManager()

    let systemSoundID: SystemSoundID = 1052 // SIMToolkitGeneralBeep.caf
    let updatesIntervalOn = 0.01
    let updatesIntervalOff = 0.1
    let gravity = 9.81
    
    func startRecordData() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.startDeviceMotionUpdates()
    }
    
    func stopRecordData(){
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.stopDeviceMotionUpdates()
    }
    
    func playSound(){
        AudioServicesPlaySystemSound(systemSoundID)
    }

}
