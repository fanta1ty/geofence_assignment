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
                SwiftLocation.requestAuthorization(.always) { _ in }
                appStateStore.dispatch(UpdateLocationAuthStatusAction(state: .rejected))
                
            case .notDetermined:
                SwiftLocation.requestAuthorization(.always) { _ in }
                appStateStore.dispatch(UpdateLocationAuthStatusAction(state: .none))
                
            default:
                appStateStore.dispatch(UpdateLocationAuthStatusAction(state: .none))
            }
        }
        
        SwiftLocation.requestAuthorization(.always) { status in
            updateStatus(status: status)
            
            Log.info("Location Service Authorization status changed to \(status.rawValue)")
        }
    }
    
    final func stop() {
        
    }
}

// MARK: - Private Functions
extension RequestLocationServiceUC {
}
