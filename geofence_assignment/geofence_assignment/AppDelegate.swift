//
//  AppDelegate.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/29/20.
//  Email: thinhnguyen12389@gmail.com
//

import UIKit
import Swinject
import IQKeyboardManagerSwift
import SVProgressHUD
import ReSwift
import TSwiftHelper

let mainAssemblerResolver = AppDelegate.assembler.resolver

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
        
    private(set) static var assembler: Assembler = Assembler(AppAssembly.allAssemblies)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupThirdPartyServices(launchOptions: launchOptions)
        launchStartPage()
        
        return true
    }
}

// MARK: - Private Functions
extension AppDelegate {
    // MARK: setupThirdPartyServices
    final private func setupThirdPartyServices(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        // MARK: IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        
        // MARK: SVProgressHUD
        SVProgressHUD.setMaxSupportedWindowLevel(.alert)
        SVProgressHUD.setDefaultMaskType(.clear)
        
        // MARK: Load all fonts
        FontHelper.loadAll()
    }
    
    // MARK: Launch Start Page Function
    final private func launchStartPage() {
        window = UIWindow()
        
        let splashVC = mainAssemblerResolver.resolve(SplashVC.self)!
        
        let navigationController = UINavigationController(rootViewController: splashVC)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .black
        navigationBarAppearace.barTintColor = .white
    }
}
