//
//  AtlasCompanionWatchAppUITestsLaunchTests.swift
//  Atlas Companion Watch AppUITests
//
//  Created by Guillermo Alcalá Gamero on 1/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import XCTest

final class AtlasCompanionWatchAppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
