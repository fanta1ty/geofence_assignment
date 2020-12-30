//
//  AppAssembly.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import Swinject
import SVProgressHUD
import ReSwift
import RxSwift

final class AppAssembly {
    // MARK: - Properties
    static var allAssemblies: [Assembly] {
        return [AppAssembly(),
                CoreAssembly(),
                UseCaseAssembly(),
                StateAssembly()]
    }
}

// MARK: - Assembly
extension AppAssembly: Assembly {
    func assemble(container: Container) {
        Log.debug("==> [AppAssembly] was initialized")
        
        SVProgressHUD.setHapticsEnabled(true)
        
        // MARK: - SplashVC
        container.register(SplashVC.self) { r in
            SplashVC()
        }
    }
}
