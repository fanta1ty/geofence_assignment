//
//  AddVMTest.swift
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

class AddVMTest: XCTestCase {
    private var testScheduler: TestScheduler!
    
    private let viewModel: AddVM = AddVM()
    private let disposeBag = DisposeBag()
    
    private let geofence: Geofence = Geofence(coordinate: CLLocationCoordinate2D(latitude: 0.01,
                                                                                 longitude: 0.01),
                                              radius: 10,
                                              type: .enter)
    
    private let addGeofenceUC: ((Geofence) -> AddGeofenceUC) = { geofence in
        mainAssemblerResolver.resolve(AddGeofenceUC.self,
                                      argument: geofence)!
    }
    
    override func setUpWithError() throws {
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        
    }
}

// MARK: - Test Cases
extension AddVMTest {
    // MARK: testViewModelCancelAction
    func testViewModelCancelAction() throws {
        var hasStartedCancel: Bool = false
        
        viewModel.output
            .onStartCancelAction
            .drive(onNext: { _ in
                hasStartedCancel = true
            })
            .disposed(by: disposeBag)
        
        let hotObs = testScheduler.createHotObservable([.next(1, ())])
        let disposable = hotObs.bind(to: viewModel.input
                                        .onCancelAction)
        
        testScheduler.scheduleAt(1) {
            disposable.dispose()
        }
        testScheduler.start()
        
        XCTAssertTrue(hasStartedCancel)
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
                                        .onCurrentLocationAction)
        
        testScheduler.scheduleAt(1) {
            disposable.dispose()
        }
        testScheduler.start()
        
        XCTAssertTrue(hasStartedCurrentLocation)
    }
    
    // MARK: testViewModelSaveAction
    func testViewModelSaveAction() throws {
        var hasStartedSaveGeofence: Bool = false
        
        viewModel.output
            .onStartSaveAction
            .subscribe(onNext: { response in
                hasStartedSaveGeofence = true
                XCTAssertEqual(response, self.geofence)
                XCTAssertTrue(hasStartedSaveGeofence)
            })
            .disposed(by: disposeBag)
        
        addGeofenceUC(geofence).start()
        let hotObs = testScheduler.createHotObservable([.next(1, geofence)])
        let disposable = hotObs.bind(to: viewModel.input
                                        .onSaveAction)
        
        testScheduler.scheduleAt(1) {
            disposable.dispose()
        }
        testScheduler.start()
    }
}
