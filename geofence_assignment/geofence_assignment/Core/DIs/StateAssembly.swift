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
    }
}
