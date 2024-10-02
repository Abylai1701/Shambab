//
//  AppDelegate.swift
//  ShambabmukliTZ
//
//  Created by Abylaikhan Abilkayr on 02.10.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        let vc = MainVC()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}
