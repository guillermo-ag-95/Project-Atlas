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
    let systemSoundID: SystemSoundID = 1052 // SIMToolkitGeneralBeep.caf
    let updatesIntervalOn = 0.01
    let updatesIntervalOff = 0.1
    
    func playSound(){
        AudioServicesPlaySystemSound(systemSoundID)
    }

}
