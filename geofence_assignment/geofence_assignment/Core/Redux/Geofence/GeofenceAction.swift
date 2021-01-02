//
//  GeofenceAction.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 1/2/21.
//

import Foundation
import ReSwift
import RxSwift
import CoreLocation
import TSwiftHelper

// MARK: LocationAuthStatus
struct UpdateAddGeofenceAction: Action {
    let state: Geofence
}

// MARK: UpdateDeleteGeofenceAction
struct UpdateDeleteGeofenceAction: Action {
    let state: Geofence
}
