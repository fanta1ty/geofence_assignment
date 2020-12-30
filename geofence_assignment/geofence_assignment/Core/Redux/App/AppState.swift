//
//  AppState.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import ReSwift
import RxSwift
import RxCocoa
import TSwiftHelper

struct AppState: StateType {
    var error: Error?
    
    var locationState = LocationState()
}
