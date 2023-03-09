//
//  AppDelegate.swift
//  Structure
//
//  Created by Changhao Li on 2023/3/6.
//

import UIKit
import Infra
import BPillar

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppRootContainer.setupForApp()
        return true
    }
}

