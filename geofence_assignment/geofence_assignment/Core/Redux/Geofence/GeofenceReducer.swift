//
//  GeofenceReducer.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 1/2/21.
//

import Foundation
import ReSwift
import RxSwift
import TSwiftHelper

func geofenceReducer(action: Action, state: GeofenceState?) -> GeofenceState {
    let state = state ?? GeofenceState()
    switch action {
    
    // MARK: Add Geofence
    case let action as UpdateAddGeofenceAction:
        state.addGeofenceState.accept(action.state)
        
    // MARK: Delete Geofence
    case let action as UpdateDeleteGeofenceAction:
        state.deleteGeofenceState.accept(action.state)
        
    // MARK: Enter Region
    case let action as UpdateEnterRegionAction:
        state.enterRegionState.accept(action.state)
        
    // MARK: Exit Region
    case let action as UpdateExitRegionAction:
        state.exitRegionState.accept(action.state)
        
    default:
        break
    }
    
    return state
}
