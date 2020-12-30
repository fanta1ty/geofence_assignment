//
//  BaseUC.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import ReSwift
import TSwiftHelper

class BaseUC {
    var appStateStore: Store<AppState> {
        mainAssemblerResolver.resolve(Store.self)!
    }
    
    func handleError(error: Error) {
        
    }
}
