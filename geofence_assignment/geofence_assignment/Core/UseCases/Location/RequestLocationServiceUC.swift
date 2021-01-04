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
                SwiftLocation.requestAuthorization(.onlyInUse) { _ in }
                appStateStore.dispatch(UpdateLocationAuthStatusAction(state: .rejected))
                
            case .notDetermined:
                SwiftLocation.requestAuthorization(.onlyInUse) { _ in }
                appStateStore.dispatch(UpdateLocationAuthStatusAction(state: .none))
                
            default:
                appStateStore.dispatch(UpdateLocationAuthStatusAction(state: .none))
            }
        }
        
        SwiftLocation.requestAuthorization(.onlyInUse) { status in
            updateStatus(status: status)
            
            Log.info("Location Service Authorization status changed to \(status.rawValue)")
        }
    }
}

// MARK: - Private Functions
extension RequestLocationServiceUC {
}
