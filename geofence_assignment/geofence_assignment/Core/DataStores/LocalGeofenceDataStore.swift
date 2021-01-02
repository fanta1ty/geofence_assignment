//
//  LocalGeofenceDataStore.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 1/2/21.
//

import Foundation
import PromiseKit

protocol LocalGeofenceDataStore {
    func get() -> Promise<[Geofence]>
    func set(_ geofence: Geofence) -> Promise<()>
    func remove(_ geofence: Geofence) -> Promise<()>
}
