//
//  LocationState.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/31/20.
//

import Foundation
import ReSwift
import RxSwift
import RxCocoa
import CoreLocation
import SwiftLocation
import TSwiftHelper

enum LocationAuthType {
    case authorized, rejected, turnOff, none
}

enum LocationStateType: String {
    case LocationAuthStatus, CurrentLocation
}

typealias LocationAuthObservable
    = Observable<LocationAuthType>

typealias CurrentLocationObservable
    = Observable<CLLocationCoordinate2D?>

struct LocationState {
    let locationAuthStatusState: BehaviorRelay<LocationAuthType> = BehaviorRelay(value: .none)
    let currentLocationState: BehaviorRelay<CLLocationCoordinate2D?> = BehaviorRelay(value: nil)
}
