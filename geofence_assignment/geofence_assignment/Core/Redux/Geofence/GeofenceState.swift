//
//  GeofenceState.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 1/2/21.
//

import Foundation
import ReSwift
import RxSwift
import RxCocoa
import CoreLocation
import SwiftLocation
import TSwiftHelper

typealias AddGeofenceObservable
    = Observable<Geofence>

typealias DeleteGeofenceObservable
    = Observable<Geofence>

enum GeofenceStateType: String {
    case add, delete
}

struct GeofenceState {
    let addGeofenceState: PublishRelay<Geofence> = PublishRelay()
    let deleteGeofenceState: PublishRelay<Geofence> = PublishRelay()
}
