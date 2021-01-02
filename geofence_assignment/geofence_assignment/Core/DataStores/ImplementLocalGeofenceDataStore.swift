//
//  ImplementLocalGeofenceDataStore.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 1/2/21.
//

import Foundation
import PromiseKit

final class ImplementLocalGeofenceDataStore {
    private let accessKey = "localGeofence"
}

// MARK: - LocalGeofenceDataStore
extension ImplementLocalGeofenceDataStore: LocalGeofenceDataStore {
    // MARK: get
    func get() -> Promise<[Geofence]> {
        return Promise { r in
            var newList = [Geofence]()
            
            guard let results = UserDefaults.standard.array(forKey: self.accessKey) else {
                return r.fulfill(newList)
            }
            
            for item in results {
                do {
                    if let geofence = try NSKeyedUnarchiver
                        .unarchiveTopLevelObjectWithData(item as! Data) as? Geofence {
                        newList.append(geofence)
                    }
                    
                } catch {
                    Log.error(error)
                }
            }
            
            r.fulfill(newList)
        }
    }
    
    // MARK: set
    func set(_ geofence: Geofence) -> Promise<()> {
        return get()
            .done { geofences in
                var newList = geofences
                newList.append(geofence)
                
                let items = NSMutableArray()
                
                for currentGeofence in newList {
                    do {
                        let item = try NSKeyedArchiver.archivedData(withRootObject: currentGeofence,
                                                                    requiringSecureCoding: false)
                        items.add(item)
                    } catch {
                        Log.error(error)
                    }
                }
                
                guard items.count < 21 else {
                    return
                }
                
                UserDefaults.standard.setValue(items, forKey: self.accessKey)
                UserDefaults.standard.synchronize()
            }
    }
    
    // MARK: remove
    func remove(_ geofence: Geofence) -> Promise<()> {
        return get()
            .done { geofences in
                var newList = geofences
                newList.removeAll { $0 == geofence }
                
                let items = NSMutableArray()
                
                for currentGeofence in newList {
                    do {
                        let item = try NSKeyedArchiver.archivedData(withRootObject: currentGeofence,
                                                                    requiringSecureCoding: false)
                        items.add(item)
                    } catch {
                        Log.error(error)
                    }
                }
                
                UserDefaults.standard.setValue(items, forKey: self.accessKey)
                UserDefaults.standard.synchronize()
            }
    }
}
