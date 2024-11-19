//
//  AppDelegate.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 03/10/2024.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            try RealmManager.shared.setUpRealm()
        } catch {
            fatalError(error.localizedDescription)
        }
        
        startMockSession()
        AppStyle.setNavigationBarAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let coordinator = AppCoordinator()
        self.coordinator = coordinator
        
        coordinator.start(animated: false)
        window?.rootViewController = coordinator.navigationController
        window?.makeKeyAndVisible()
                
        return true
    }
    
    private func startMockSession() {
        UserSession.shared = UserSession(userId: User.mockCurrentUser.id)
    }
}
