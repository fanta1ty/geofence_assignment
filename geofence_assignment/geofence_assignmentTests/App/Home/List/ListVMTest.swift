//
//  ListVMTest.swift
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

class ListVMTest: XCTestCase {
    private var testScheduler: TestScheduler!
    
    private let viewModel: ListVM = ListVM()
    private let disposeBag = DisposeBag()
    
    private let geofence: Geofence = Geofence(coordinate: CLLocationCoordinate2D(latitude: 0.02,
                                                                                 longitude: 0.02),
                                              radius: 10,
                                              type: .enter)
    
    private let deleteGeofenceUC: ((Geofence) -> DeleteGeofenceUC) = { geofence in
        mainAssemblerResolver.resolve(DeleteGeofenceUC.self, argument: geofence)!
    }
    
    override func setUpWithError() throws {
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        
    }
}

// MARK: - Test Cases
extension ListVMTest {
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
    
    // MARK: testViewModelDeleteGeofenceAction
    func testViewModelDeleteGeofenceAction() throws {
        var hasStartedDeleteGeofence: Bool = false
        
        viewModel.output
            .onStartDeleteGeofenceAction
            .subscribe(onNext: { response in
                hasStartedDeleteGeofence = true
                
                XCTAssertTrue(hasStartedDeleteGeofence)
                XCTAssertEqual(self.geofence, response)
            })
            .disposed(by: disposeBag)
        deleteGeofenceUC(geofence).start()
    }
}
