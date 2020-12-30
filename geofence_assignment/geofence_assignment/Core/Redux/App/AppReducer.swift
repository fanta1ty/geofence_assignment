//
//  AppReducer.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import ReSwift
import TSwiftHelper

func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch action {
    default:
        return state
    }
    
    return state
}
