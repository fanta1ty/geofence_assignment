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
        state.locationState = locationReducer(action: action,
                                              state: state.locationState)
        state.geofenceState = geofenceReducer(action: action,
                                              state: state.geofenceState)
    }
    
    return state
}
