//
//  AppDelegate.swift
//  PillsPromise
//
//  Created by guest on 2019/11/15.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit
import UserNotifications
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SingletoneMedicineList.shared.medicineList.load()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        SingletoneMedicineList.shared.medicineList.save()
    }
    func applicationWillResignActive(_ application: UIApplication) {
        SingletoneMedicineList.shared.medicineList.save()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        SingletoneMedicineList.shared.medicineList.save()
    }

}

public extension FileManager {
    static var documentDirectoryURL: URL {
        return self.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

