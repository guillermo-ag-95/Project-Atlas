//
//  ResultInterfaceController.swift
//  Atlas WatchKit Extension
//
//  Created by Guillermo Alcalá Gamero on 27/5/18.
//  Copyright © 2018 Guillermo Alcalá Gamero. All rights reserved.
//

import WatchKit

class ResultInterfaceController: WKInterfaceController {

    @IBOutlet var resultTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        initializeResultTable(context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func initializeResultTable(_ context: Any?){
        let data = context as! [[Double]]
        
        let maxVelocities = data[0]
        let meanVelocities = data[1]
        
        print("Max velocities: \(maxVelocities)")
        print("Mean velocities: \(meanVelocities)")
        
        // Initialize the row types.
        resultTable.setNumberOfRows(maxVelocities.count, withRowType: "ResultRowType")

        // Initialize the row data.
        for i in 0..<maxVelocities.count {
            let rowController = resultTable.rowController(at: i) as! ResultRowController
            let maxVelocity = String(format: "%.2f", maxVelocities[i])
            let meanVelocity = String(format: "%.2f", meanVelocities[i])
            rowController.repetitionLabel.setText("Repetition \(i + 1)")
            rowController.maxVelocityLabel.setText("Max: \(maxVelocity)")
            rowController.meanVelocityLabel.setText("Mean: \(meanVelocity)")
        }
    }
}
