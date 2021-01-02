//
//  Geofence.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/31/20.
//

import Foundation
import MapKit
import CoreLocation

enum GeofenceType: Int {
    case enter, exit
}

class Geofence: NSObject, NSCoding, MKAnnotation {
    static let latitudeKey = "latitude"
    static let longitudeKey = "longitude"
    static let radiusKey = "radius"
    static let identifierKey = "identifier"
    static let typeKey = "type"
    
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String = UUID().uuidString
    var type: GeofenceType
    
    var title: String? {
        return "Geofence"
    }
    
    var subtitle: String? {
        let typeStr = type == .enter ? "Enter" : "Exit"
        return "Radius: \(radius)m, Type: \(typeStr)"
    }
    
    init(coordinate: CLLocationCoordinate2D,
         radius: CLLocationDistance,
         type: GeofenceType) {
        self.coordinate = coordinate
        self.radius = radius
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        let lat = coder.decodeDouble(forKey: Geofence.latitudeKey)
        let lon = coder.decodeDouble(forKey: Geofence.longitudeKey)
        coordinate = CLLocationCoordinate2D(latitude: lat,
                                            longitude: lon)
        radius = coder.decodeDouble(forKey: Geofence.radiusKey)
        identifier = coder.decodeObject(forKey: Geofence.identifierKey) as! String
        type = GeofenceType(rawValue: coder.decodeInteger(forKey: Geofence.typeKey))!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(coordinate.latitude, forKey: Geofence.latitudeKey)
        coder.encode(coordinate.longitude, forKey: Geofence.longitudeKey)
        coder.encode(radius, forKey: Geofence.radiusKey)
        coder.encode(identifier, forKey: Geofence.identifierKey)
        coder.encode(Int32(type.rawValue), forKey: Geofence.typeKey)
    }
}
