//
//  Log.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import SwiftyBeaver
import TSwiftHelper

typealias Log = SwiftyBeaver

func setupLogger() {
    // SwiftyBeaver logging
    let console = ConsoleDestination()
    console.format = "$DHH:mm:ss$d $C$L$c $M"
    console.minLevel = .verbose
    SwiftyBeaver.addDestination(console)
}
