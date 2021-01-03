//
//  AddGeofenceUC.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 1/2/21.
//

import Foundation
import CoreLocation
import SwiftLocation
import PromiseKit
import ReSwift
import TSwiftHelper
import SwiftLocation

final class AddGeofenceUC: BaseUC {
    // MARK: Local Properties
    private let geofence: Geofence
    
    init(geofence: Geofence) {
        self.geofence = geofence
        super.init()
    }
}

// MARK: - Public Functions
extension AddGeofenceUC {
    final func start() {
        _ = storedGeofence(geofence: geofence)
            .done(updateState(state: ))
    }
}

// MARK: - Private Functions
extension AddGeofenceUC {
    final private func storedGeofence(geofence: Geofence) -> Promise<Geofence> {
        return Promise { r in
            let geofenceDataStore = mainAssemblerResolver.resolve(LocalGeofenceDataStore.self)!
            _ = geofenceDataStore.set(geofence)
            
            r.fulfill(geofence)
        }
    }
    
    // MARK: updateState
    final private func updateState(state: Geofence) {
        appStateStore.dispatch(UpdateAddGeofenceAction(state: state))
    }
}
