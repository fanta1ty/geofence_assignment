//
//  GetCurrentLocationUC.swift
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

final class GetCurrentLocationUC: BaseUC {
}

// MARK: - Public Functions
extension GetCurrentLocationUC {
    final func start() {
        getCurrentLocation()
    }
}

// MARK: - Private Functions
extension GetCurrentLocationUC {
    // MARK: updateState
    final private func updateState(state: CLLocationCoordinate2D) {
        appStateStore.dispatch(UpdateCurrentLocationAction(state: state))
    }
}

// MARK: - Action Functions
extension GetCurrentLocationUC {
    // MARK: getCurrentLocation
    @objc final private func getCurrentLocation() {
        SwiftLocation.allowsBackgroundLocationUpdates = true
        
        SwiftLocation.gpsLocationWith {
            $0.subscription = .single
            $0.accuracy = .city
        }
        .then { result in
            switch result {
            case .success(let location):
                self.updateState(state: location.coordinate)
                
            case .failure(let error):
                Log.error(error)
            }
        }
    }
}
