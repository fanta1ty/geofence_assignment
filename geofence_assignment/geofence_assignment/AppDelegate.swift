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
import RxSwift
import ReSwift
import TSwiftHelper
import SwiftLocation

let mainAssemblerResolver = AppDelegate.assembler.resolver

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private(set) static var assembler: Assembler = Assembler(AppAssembly.allAssemblies)
    private let disposeBag = DisposeBag()
    
    private var enterRegionState: EnterRegionObservable {
        return mainAssemblerResolver.resolve(EnterRegionObservable.self,
                                             name: GeofenceStateType.enter.rawValue)!
    }
    
    private var exitRegionState: ExitRegionObservable {
        return mainAssemblerResolver.resolve(ExitRegionObservable.self,
                                             name: GeofenceStateType.exit.rawValue)!
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupThirdPartyServices(launchOptions: launchOptions)
        launchStartPage()
        
        handleEnterRegion()
        handleExitRegion()
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }
}

// MARK: - Private Functions
extension AppDelegate {
    // MARK: handleEnterRegion
    final private func handleEnterRegion() {
        enterRegionState.subscribe(onNext: { region in
            if UIApplication.shared.applicationState == .background {
                self.sendLocalPushNotification(title: "Geofence",
                                               subtitle: "Did Enter Region: \(region)")
            }
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: handleExitRegion
    final private func handleExitRegion() {
        exitRegionState.subscribe(onNext: { region in
            if UIApplication.shared.applicationState == .background {
                self.sendLocalPushNotification(title: "Geofence",
                                               subtitle: "Did Exit Region: \(region)")
            }
        })
        .disposed(by: disposeBag)
    }
    
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
    
    final private func sendLocalPushNotification(title: String, subtitle: String,
                                                 afterInterval: TimeInterval = 3) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: afterInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - Static Functions
extension AppDelegate {
    
}
