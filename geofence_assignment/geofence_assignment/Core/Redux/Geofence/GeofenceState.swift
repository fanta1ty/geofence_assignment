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

typealias EnterRegionObservable
    = Observable<CLRegion>

typealias ExitRegionObservable
    = Observable<CLRegion>

enum GeofenceStateType: String {
    case add, delete, enter, exit
}

struct GeofenceState {
    let addGeofenceState: PublishRelay<Geofence> = PublishRelay()
    let deleteGeofenceState: PublishRelay<Geofence> = PublishRelay()
    let enterRegionState: PublishRelay<CLRegion> = PublishRelay()
    let exitRegionState: PublishRelay<CLRegion> = PublishRelay()
}
