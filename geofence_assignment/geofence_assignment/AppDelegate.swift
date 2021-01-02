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
import SwiftLocation

let NOTIFICATION_VISITS_DATA = Notification.Name("NOTIFICATION_VISITS_DATA")
let mainAssemblerResolver = AppDelegate.assembler.resolver

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
        
    private(set) static var assembler: Assembler = Assembler(AppAssembly.allAssemblies)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SwiftLocation.onRestoreGeofences = AppDelegate.onRestoreGeofencedRequests
        SwiftLocation.onRestoreVisits = AppDelegate.onRestoreVisitsRequests
        
        UNUserNotificationCenter.current().delegate = self
        AppDelegate.enablePushNotifications()
        
        setupThirdPartyServices(launchOptions: launchOptions)
        launchStartPage()
        
        return true
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
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

// MARK: - Static Functions
extension AppDelegate {
    // MARK: enablePushNotifications
    private static func enablePushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { _,_ in
                
            }
    }
    
    // MARK: attachSubscribersToGeofencedRegions
    static func attachSubscribersToGeofencedRegions(_ requests: [GeofencingRequest]) {
        for item in requests {
            item.cancelAllSubscriptions()
            
            item.then(queue: .main) { result in
                switch result {
                case .success(let event):
                    Log.debug("[Geofence]: \(event)")
                    sendNotification(title: "New Geofence Event",
                                     subtitle: event.description,
                                     object: result.description)
                    
                case .failure(let error):
                    Log.error("[Geofence]: \(error)")
                    sendNotification(title: "Geofence Error",
                                     subtitle: error.localizedDescription,
                                     object: result.description)
                }
            }
        }
    }
    
    // MARK: sendNotification
    static func sendNotification(title: String,
                                 subtitle: String,
                                 object: Any? = nil,
                                 afterInterval: TimeInterval = 3) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        if let object = object {
            content.userInfo = ["result": object]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: afterInterval,
                                                        repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current()
            .add(request)
    }
    
    // MARK: onRestoreGeofencedRequests
    public static func onRestoreGeofencedRequests(_ requests: [GeofencingRequest]) {
        guard requests.isEmpty == false else {
            return
        }
        
        AppDelegate.attachSubscribersToGeofencedRegions(requests)
    }
    
    // MARK: onRestoreVisitsRequests
    public static func onRestoreVisitsRequests(_ requests: [VisitsRequest]) {
        guard requests.isEmpty == false else {
            return
        }
        
        attachSubscribersToVisitsRegions(requests)
    }
    
    // MARK: attachSubscribersToVisitsRegions
    public static func attachSubscribersToVisitsRegions(_ requests: [VisitsRequest?]) {
        for request in requests {
            if let unwrappedRequest = request {
                unwrappedRequest.then(queue: .main) { result in
                    NotificationCenter.default.post(name: NOTIFICATION_VISITS_DATA, object: result, userInfo: nil)

                    switch result {
                    case .success(let visit):
                        sendNotification(title: "New Enter",
                                         subtitle: visit.description,
                                         object: result.description)
                        
                    case .failure(let error):
                        sendNotification(title: "Enter Error",
                                         subtitle: error.localizedDescription,
                                         object: result.description)
                    }
                }
            }
        }
    }
}
