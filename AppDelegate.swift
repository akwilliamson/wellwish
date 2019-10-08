//
//  AppDelegate.swift
//  date_dots
//
//  Created by Aaron Williamson on 8/17/19.
//  Copyright © 2019 Aaron Williamson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = getInitialViewController()
        window?.makeKeyAndVisible()

        return true
    }
    
    private func getInitialViewController() -> UIViewController {
        return ListViewController()
    }
}
