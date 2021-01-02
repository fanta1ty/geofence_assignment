//
//  StateAssembly.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import Swinject
import ReSwift
import RxSwift
import TSwiftHelper

final class StateAssembly {
    
}

// MARK: - Assembly
extension StateAssembly: Assembly {
    func assemble(container: Container) {
        Log.debug("==> [StateAssembly] was initialized")
        
        // MARK: - Location Section
        // MARK: LocationAuthObservable
        container.register(LocationAuthObservable.self, name: LocationStateType.LocationAuthStatus.rawValue) { r in
            let appStateStore: Store<AppState> = r.resolve(Store.self)!
            return appStateStore.state.locationState.locationAuthStatusState.asObservable()
        }
        
        // MARK: CurrentLocationObservable
        container.register(CurrentLocationObservable.self, name: LocationStateType.CurrentLocation.rawValue) { r in
            let appStateStore: Store<AppState> = r.resolve(Store.self)!
            return appStateStore.state.locationState.currentLocationState.asObservable()
        }
        
        // MARK: - Geofence Section
        // MARK: AddGeofenceObservable
        container.register(AddGeofenceObservable.self, name: GeofenceStateType.add.rawValue) { r in
            let appStateStore: Store<AppState> = r.resolve(Store.self)!
            return appStateStore.state.geofenceState.addGeofenceState.asObservable()
        }
    }
}
