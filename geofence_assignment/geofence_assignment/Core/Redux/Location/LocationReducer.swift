//
//  LocationReducer.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/31/20.
//

import Foundation
import ReSwift
import RxSwift
import TSwiftHelper

func locationReducer(action: Action, state: LocationState?) -> LocationState {
    let state = state ?? LocationState()
    switch action {
    
    // MARK: Location Auth Status
    case let action as UpdateLocationAuthStatusAction:
        state.locationAuthStatusState.accept(action.state)
        
    // MARK: Current location
    case let action as UpdateCurrentLocationAction:
        state.currentLocationState.accept(action.state)
        
    default:
        break
    }
    
    return state
}
