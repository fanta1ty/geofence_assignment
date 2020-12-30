//
//  RequestLocationServiceUC.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/31/20.
//

import Foundation
import CoreLocation
import SwiftLocation
import PromiseKit
import ReSwift
import TSwiftHelper

final class RequestLocationServiceUC: BaseUC {
    
}

// MARK: - Public Functions
extension RequestLocationServiceUC {
    final func start() {
        func updateStatus(status: CLAuthorizationStatus) {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                appStateStore.dispatch(UpdateLocationAuthStatusAction(state: .authorized))
                
            case .denied:
                Locator.requestAuthorizationIfNeeded()
                appStateStore.dispatch(UpdateLocationAuthStatusAction(state: .rejected))
                
            case .notDetermined:
                Locator.requestAuthorizationIfNeeded()
                appStateStore.dispatch(UpdateLocationAuthStatusAction(state: .none))
                
            default:
                appStateStore.dispatch(UpdateLocationAuthStatusAction(state: .none))
            }
        }
        
        updateStatus(status: Locator.authorizationStatus)
        _ = Locator.events.listen { newStatus in
            updateStatus(status: newStatus)
            Log.info("Location Service Authorization status changed to \(newStatus.rawValue)")
        }
    }
    
    final func stop() {
        
    }
}

// MARK: - Private Functions
extension RequestLocationServiceUC {
}
