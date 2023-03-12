//
//  AppRouter.swift
//  InfraUI
//
//  Created by Changhao Li on 2023/3/9.
//

import Foundation

public protocol AppRouterProtocol: AnyObject {
    func getViewController(path: AppRouterPath) -> UIViewController?
//    func mapDeepLinkRoute(from route: AppRoute) -> DeepLinkRoute?
}

public protocol AppRouterPathParamProtocol: AnyObject {

}

public protocol AppPageRouterPathProtocol {

}

public enum AppRouterPath {
    case aPillar(page: AppPageRouterPathProtocol)
    case bPillar(page: AppPageRouterPathProtocol)
}

public class AppRouter: NSObject, UITabBarControllerDelegate {

    public static let shared = AppRouter()

    /**
     The root view controller for the application.
     */

    public private(set) var rootViewController = AppRootContainerViewController()

    public var aPillarRouter: AppRouterProtocol?
    public var bPillarRouter: AppRouterProtocol?

    public var allRouters: [AppRouterProtocol] {
        [aPillarRouter, bPillarRouter].compactMap { $0 }
    }

    private func getPillarRouter(path: AppRouterPath) -> AppRouterProtocol? {

        switch path {
        case .aPillar:
            return aPillarRouter
        case .bPillar:
            return bPillarRouter
        }
    }

    public func resetRootViewController() {
        rootViewController = AppRootContainerViewController()
    }

}

// MARK: - AppRouterProtocol

extension AppRouter: AppRouterProtocol {

    public func getViewController(path: AppRouterPath) -> UIViewController? {
        guard let pillarRouter = getPillarRouter(path: path) else {
            assertionFailure("Can not get pillarDelegate from path:\(path) go to AppRouterRegister to setup pillarDelegate")
            return nil
        }
        return pillarRouter.getViewController(path: path)
    }

//    public func mapDeepLinkRoute(from route: AppRoute) -> DeepLinkRoute? {
//        let routers = allRouters.compactMap { $0.mapDeepLinkRoute(from: route) }
//        if routers.count > 1 {
//            assertionFailure("More than one router can response route \(route) which is not allowed")
//        }
//        return routers.first
//    }
}

extension AppRouter {
    /**
     Returns the view controller of the currently selected tab.
     */
    public func currentSelectedTabViewController() -> UIViewController? {
        if let tabBarController = rootViewController.childViewController as? UITabBarController {
            return tabBarController.selectedViewController
        } else {
            return nil
        }
    }

    /**
     Returns the index of the currently selected tab.
     */
    public func currentSelectedTabIndex() -> Int {
        if let tabBarController = rootViewController.childViewController as? UITabBarController {
            return tabBarController.selectedIndex
        } else {
            return 0
        }
    }
}
