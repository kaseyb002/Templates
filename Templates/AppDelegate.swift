//
//  AppDelegate.swift
//  Templates
//
//  Created by Kasey Baughan on 2/23/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var rootFlow: RootFlow!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navVC = UINavigationController()
        rootFlow = RootFlow(navVC: navVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        rootFlow.startApp()
        
        return true
    }
}
