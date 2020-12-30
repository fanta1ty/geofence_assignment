//
//  UseCaseAssembly.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import Swinject
import ReSwift
import RxSwift
import TSwiftHelper

final class UseCaseAssembly {
    
}

// MARK: - Assembly
extension UseCaseAssembly: Assembly {
    func assemble(container: Container) {
        Log.debug("==> [UseCaseAssembly] was initialized")
        
        // MARK: - BaseUC
        container.register(BaseUC.self) { r in
            BaseUC()
        }
    }
}
