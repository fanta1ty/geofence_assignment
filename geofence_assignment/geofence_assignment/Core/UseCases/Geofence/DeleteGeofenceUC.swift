//
//  DeleteGeofenceUC.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 1/3/21.
//

import Foundation
import CoreLocation
import SwiftLocation
import PromiseKit
import ReSwift
import TSwiftHelper
import SwiftLocation

final class DeleteGeofenceUC: BaseUC {
    // MARK: Local Properties
    private let geofence: Geofence
    
    init(geofence: Geofence) {
        self.geofence = geofence
        super.init()
    }
}

// MARK: - Public Functions
extension DeleteGeofenceUC {
    final func start() {
        updateState(state: geofence)
    }
}

// MARK: - Private Functions
extension DeleteGeofenceUC {
    // MARK: updateState
    final private func updateState(state: Geofence) {
        appStateStore.dispatch(UpdateDeleteGeofenceAction(state: state))
    }
}
