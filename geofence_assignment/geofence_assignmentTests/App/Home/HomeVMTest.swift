//
//  HomeVMTest.swift
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

class HomeVMTest: XCTestCase {
    private var testScheduler: TestScheduler!
    
    private let viewModel: HomeVM = HomeVM()
    private let disposeBag = DisposeBag()
    
    private let geofence: Geofence = Geofence(coordinate: CLLocationCoordinate2D(latitude: 0.01,
                                                                                 longitude: 0.01),
                                              radius: 10,
                                              type: .enter)
    
    private let addGeofenceUC: ((Geofence) -> AddGeofenceUC) = { geofence in
        mainAssemblerResolver.resolve(AddGeofenceUC.self,
                                      argument: geofence)!
    }
    
    private let deleteGeofenceUC: ((Geofence) -> DeleteGeofenceUC) = { geofence in
        mainAssemblerResolver.resolve(DeleteGeofenceUC.self, argument: geofence)!
    }
    
    private let monitorGeofenceUC: (() -> MonitorGeofenceUC) = {
        mainAssemblerResolver.resolve(MonitorGeofenceUC.self)!
    }
    
    private let getCurrentLocationUC: (() -> GetCurrentLocationUC) = {
        mainAssemblerResolver.resolve(GetCurrentLocationUC.self)!
    }
    
    override func setUpWithError() throws {
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        
    }
}

// MARK: - Test Cases
extension HomeVMTest {
    // MARK: testViewModelAddAction
    func testViewModelAddAction() throws {
        var hasStartedAdd: Bool = false
        
        viewModel.output
            .onStartAddAction
            .drive(onNext: { _ in
                hasStartedAdd = true
            })
            .disposed(by: disposeBag)
        
        let hotObs = testScheduler.createHotObservable([.next(1, ())])
        let disposable = hotObs.bind(to: viewModel.input
                                        .onAddAction)
        
        testScheduler.scheduleAt(1) {
            disposable.dispose()
        }
        testScheduler.start()
        
        XCTAssertTrue(hasStartedAdd)
    }
    
    // MARK: testViewModelListAction
    func testViewModelListAction() throws {
        var hasStartedList: Bool = false
        
        viewModel.output
            .onStartListAction
            .drive(onNext: {
                hasStartedList = true
            })
            .disposed(by: disposeBag)
        
        let hotObs = testScheduler.createHotObservable([.next(1, ())])
        let disposable = hotObs.bind(to: viewModel.input
                                        .onListAction)
        
        testScheduler.scheduleAt(1) {
            disposable.dispose()
        }
        testScheduler.start()
        
        XCTAssertTrue(hasStartedList)
    }
    
    // MARK: testViewModelLocationAuthAction
    func testViewModelLocationAuthAction() throws {
        var hasStartedLocationAuth: Bool = false
        
        viewModel.output
            .onStartLocationAuthAction
            .subscribe(onNext: { type in
                hasStartedLocationAuth = true
                XCTAssertEqual(type, LocationAuthType.none)
            })
            .disposed(by: disposeBag)
        
        let hotObs = testScheduler.createHotObservable([.next(1, ())])
        let disposable = hotObs.bind(to: viewModel.input
                                        .onRequestLocationServiceAction)
        
        testScheduler.scheduleAt(1) {
            disposable.dispose()
        }
        testScheduler.start()
        
        XCTAssertTrue(hasStartedLocationAuth)
    }
    
    // MARK: testViewModelCurrentLocationAction
    func testViewModelCurrentLocationAction() throws {
        var hasStartedCurrentLocation: Bool = false
        
        viewModel.output
            .onStartCurrentLocationAction
            .subscribe(onNext: { location in
                hasStartedCurrentLocation = true
            })
            .disposed(by: disposeBag)
        
        let hotObs = testScheduler.createHotObservable([.next(1, ())])
        let disposable = hotObs.bind(to: viewModel.input
                                        .onGetCurrentLocationAction)
        
        testScheduler.scheduleAt(1) {
            disposable.dispose()
        }
        testScheduler.start()
        
        XCTAssertTrue(hasStartedCurrentLocation)
    }
    
    func testCurrentLocationAction() throws {
        var hasStartedCurrentLocation: Bool = false
        
        viewModel.output
            .onStartCurrentLocationAction
            .subscribe(onNext: { location in
                hasStartedCurrentLocation = true
                XCTAssertTrue(hasStartedCurrentLocation)
            })
            .disposed(by: disposeBag)
        
        getCurrentLocationUC().start()
    }
    
    // MARK: testViewModelAddGeofenceAction
    func testViewModelAddGeofenceAction() throws {
        var hasStartedAddGeofence: Bool = false
        
        viewModel.output
            .onStartAddGeofenceAction
            .subscribe(onNext: { response in
                hasStartedAddGeofence = true
                XCTAssertEqual(response, self.geofence)
                XCTAssertTrue(hasStartedAddGeofence)
            })
            .disposed(by: disposeBag)
        
        addGeofenceUC(geofence).start()
    }
    
    // MARK: testViewModelMonitorGeofenceAction
    func testViewModelMonitorGeofenceAction() throws {
        var hasStartedMonitorGeofence: Bool = false
        
        viewModel.output
            .onStartMonitorGeofenceAction
            .drive(onNext: { _ in
                hasStartedMonitorGeofence = true
                XCTAssertTrue(hasStartedMonitorGeofence)
            })
            .disposed(by: disposeBag)
        
        monitorGeofenceUC().start()
    }
    
    // MARK: testViewModelDeleteGeofenceAction
//    func testViewModelDeleteGeofenceAction() throws {
//        var hasStartedDeleteGeofence: Bool = false
//        
//        viewModel.output
//            .onStartDeleteGeofenceAction
//            .subscribe(onNext: { response in
//                hasStartedDeleteGeofence = true
//                
//                XCTAssertTrue(hasStartedDeleteGeofence)
//                XCTAssertEqual(self.geofence, response)
//            })
//            .disposed(by: disposeBag)
//        
//        deleteGeofenceUC(geofence).start()
//    }
}
