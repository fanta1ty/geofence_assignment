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

final class MonitorGeofenceUC: BaseUC {
    // MARK: Local Properties
    private let locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
}

extension MonitorGeofenceUC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        Log.debug("[Start Monitoring]: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        Log.error("[Monitoring Failed]: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        appStateStore.dispatch(UpdateEnterRegionAction(state: region))
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        appStateStore.dispatch(UpdateExitRegionAction(state: region))
    }
}

// MARK: - Public Functions
extension MonitorGeofenceUC {
    final func start() {
        _ = monitorGeofence()
    }
    
    final func stop(geofence: Geofence) {
        for region in locationManager.monitoredRegions {
          if let circularRegion = region as? CLCircularRegion {
            if circularRegion.identifier == geofence.identifier {
              locationManager.stopMonitoring(for: region)
            }
          }
        }
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
                        let region = CLCircularRegion(center: geofence.coordinate,
                                                      radius: geofence.radius,
                                                      identifier: geofence.identifier)
                        region.notifyOnEntry = geofence.type == .enter ? true : false
                        region.notifyOnExit = !region.notifyOnEntry
                        
                        self.locationManager.startMonitoring(for: region)
                    }
                    
                    r.fulfill(())
                }
            }
        }
    
    // MARK: updateState
    final private func updateState() {
    }
}
