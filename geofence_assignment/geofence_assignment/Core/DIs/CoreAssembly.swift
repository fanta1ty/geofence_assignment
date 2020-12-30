//
//  CoreAssembly.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import Swinject
import ReSwift
import RxSwift
import TSwiftHelper

enum CoreAssemblyType: String {
    case Store
}

final class CoreAssembly {
    
}

// MARK: - Assembly
extension CoreAssembly: Assembly {
    func assemble(container: Container) {
        Log.debug("==> [CoreAssembly] was initialized")
        setupLogger()
        
        // MARK: Store
        container.register(Store.self) { r in
            Store(reducer: appReducer, state: nil)
        }.inObjectScope(.container)
    }
}
