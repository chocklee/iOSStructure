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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppRootContainer.setupForApp()
        let openB = OpenB()
        print(openB.appName())
        return true
    }
}

