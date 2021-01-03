//
//  GeofenceTest.swift
//  geofence_assignmentTests
//
//  Created by Thinh Nguyen on 1/3/21.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import CoreLocation

@testable import geofence_assignment

class GeofenceTest: XCTestCase {
    private let geofence: Geofence = Geofence(coordinate: CLLocationCoordinate2D(latitude: 0.01,
                                                                                 longitude: 0.01),
                                              radius: 10,
                                              type: .enter)
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
}

extension GeofenceTest {
    func testGeofenceName() throws {
        XCTAssertEqual("Enter", geofence.type.name)
        geofence.type = .exit
        XCTAssertEqual("Exit", geofence.type.name)
    }
    
    func testGeofenceTitle() throws {
        XCTAssertEqual("Geofence", geofence.title!)
        XCTAssertNotNil(geofence.subtitle)
        geofence.type = .exit
        XCTAssertNotNil(geofence.subtitle)
    }
    
    func testGeofenceEncode() throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: geofence,
                                                    requiringSecureCoding: false)
        let decodedGeofence = try NSKeyedUnarchiver
        .unarchiveTopLevelObjectWithData(data) as? Geofence
        
        XCTAssertNotNil(decodedGeofence)
    }
}
