//
//  MonitorGeofenceUC.swift
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

final class MonitorGeofenceUC: BaseUC {
    // MARK: Local Properties
    
    override func handleError(error: Error) {
        super.handleError(error: error)
    }
}

// MARK: - Public Functions
extension MonitorGeofenceUC {
    final func start() {
        _ = monitorGeofence()
            .done(updateState)
    }
}

// MARK: - Private Functions
extension MonitorGeofenceUC {
    // MARK: monitorGeofence
    final private func monitorGeofence() -> Promise<()> {
        return Promise { r in
            let geofenceDataStore = mainAssemblerResolver.resolve(LocalGeofenceDataStore.self)!
            
            _ = geofenceDataStore.get()
                .done { geofences in
                    for geofence in geofences {
                        let options = GeofencingOptions(circleWithCenter: geofence.coordinate,
                                                        radius: geofence.radius)
                        SwiftLocation.geofenceWith(options)
                    }
                    
                    r.fulfill(())
                }
            }
        }
    
    // MARK: updateState
    final private func updateState() {
        AppDelegate.attachSubscribersToGeofencedRegions(Array(SwiftLocation.geofenceRequests.list))
    }
}

// MARK: - Action Functions
extension MonitorGeofenceUC {
    
}
