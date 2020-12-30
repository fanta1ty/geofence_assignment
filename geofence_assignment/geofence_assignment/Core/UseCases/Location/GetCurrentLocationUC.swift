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
    // MARK: Local Properties
    private var timer = Timer()
    
    override func handleError(error: Error) {
        super.handleError(error: error)
        
        Log.error("==> [GetCurrentLocationUC] error to get current location: \(error)")
    }
}

// MARK: - Public Functions
extension GetCurrentLocationUC {
    final func start() {
        getCurrentLocation()
    }
    
    @objc final func stopTimer() {
        timer.invalidate()
    }
    
    @objc final func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60,
                                     target: self,
                                     selector: #selector(getCurrentLocation),
                                     userInfo: nil,
                                     repeats: false)
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
        Locator.currentPosition(accuracy: .city) { location in
            self.updateState(state: location.coordinate)
        } onFail: { error, _ in
            self.handleError(error: error)
        }
    }
}
