//
//  LocationAction.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/31/20.
//

import Foundation
import ReSwift
import RxSwift
import CoreLocation
import TSwiftHelper

// MARK: LocationAuthStatus
struct UpdateLocationAuthStatusAction: Action {
    let state: LocationAuthType
}

// MARK: CurrentLocation
struct UpdateCurrentLocationAction: Action {
    let state: CLLocationCoordinate2D?
}
