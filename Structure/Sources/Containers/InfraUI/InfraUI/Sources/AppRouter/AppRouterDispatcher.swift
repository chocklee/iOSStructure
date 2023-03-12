//
//  AppRouterDispatcher.swift
//  InfraUI
//
//  Created by Changhao Li on 2023/3/9.
//

import UIKit

public enum AppRouterPresentStyle {

    /// Push a view contorller
    case push

    /// Present a view controller
    case present

    /// Present a view controller and wrapped it in a `NavigationCotnroller`
    case presentWrappedByNavigationController

    /// Present the view contorller on `AppRootContainerViewController`
    case presentOnRoot

    /// Present the view controller on `AppRootContainerViewController` and wrapped it in a `NavigationCotnroller`
    case presentOnRootWrappedByNavigationController
}

public typealias AppRouterDispatcherEvent = (path: AppRouterPath, style: AppRouterPresentStyle, animated: Bool)

public protocol AppRouterDispatcherEventEnqueueListener: AnyObject {
    func enqueueEvent(_ event: AppRouterDispatcherEvent?)
}

public class AppRouterDispatcher: NSObject {

    public static var shared = AppRouterDispatcher()

    private override init() {}

    public func getCurrentViewController() -> UIViewController? {

        let rootViewController = AppRouter.shared.rootViewController
        if let child = rootViewController.childViewController {
            return getTopMostViewController(child)
        } else {
            return rootViewController
        }
    }

    private func getTopMostViewController(_ viewController: UIViewController) -> UIViewController {
        let navigationController = viewController as? UINavigationController ?? nil
        let tabBarController = viewController as? UITabBarController ?? nil
        if let topViewController = navigationController?.topViewController {
            return getTopMostViewController(topViewController)
        } else if let selectedViewController = tabBarController?.selectedViewController {
            return getTopMostViewController(selectedViewController)
        } else if let presentedViewController = viewController.presentedViewController {
            return getTopMostViewController(presentedViewController)
        } else {
            return viewController
        }
    }

    @discardableResult
    public func showViewController(path: AppRouterPath,
                                   style: AppRouterPresentStyle = .push,
                                   animated: Bool = true,
                                   completion: (() -> Void)? = nil) -> UIViewController? {
        guard let targetVC = AppRouter.shared.getViewController(path: path) else {
            return nil
        }
        showViewController(targetVC: targetVC, style: style, animated: animated, completion: completion)
        return targetVC
    }

    public func showViewController(targetVC: UIViewController,
                                   style: AppRouterPresentStyle = .push,
                                   animated: Bool = true,
                                   completion: (() -> Void)? = nil) {
        guard let currentVC = getCurrentViewController() else {
            assertionFailure("Can't find the current view controller")
            return
        }

        let prensentingViewController = currentVC.navigationController ?? currentVC
        let rootViewController = AppRouter.shared.rootViewController

        switch style {
        case .push:
            currentVC.navigationController?.pushViewController(targetVC, animated: animated)
        case .present:
            // To coordinate with old logic, use navigtaioncontroller to present
            prensentingViewController.present(targetVC, animated: animated, completion: completion)
        case .presentWrappedByNavigationController:
            prensentingViewController.present(UINavigationController(rootViewController: targetVC), animated: animated, completion: completion)
        case .presentOnRoot:
            rootViewController.present(targetVC, animated: animated, completion: completion)
        case .presentOnRootWrappedByNavigationController:
            rootViewController.present(UINavigationController(rootViewController: targetVC), animated: animated, completion: completion)
        }
    }

    public func dismissModalViewControllers(_ animated: Bool, completion: (() -> Void)?) {
        // We present modals on the `rootViewController` or the `mainNavViewController`. Until this is standardized, we have to check both.
        let rootViewController = AppRouter.shared.rootViewController
        let tabBarController = rootViewController.childViewController as? UITabBarController
        let dismissTabBarModals = { (handler: (() -> Void)?) in
            if let tabBarController = tabBarController, tabBarController.presentedViewController != nil {
                tabBarController.dismiss(animated: animated, completion: handler)
            } else {
                handler?()
            }
        }

        if rootViewController.presentedViewController != nil {
            rootViewController.dismiss(animated: animated, completion: {
                dismissTabBarModals(completion)
            })
        } else {
            dismissTabBarModals(completion)
        }
    }

    // MARK: Private utils

    /**
     Get the top most view controller that is presented in the app.
     */
    private func topViewController() -> UIViewController? {
        var topController: UIViewController? = AppRouter.shared.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }

    // if selectedViewController.presentedViewController is not nil, which means there is ViewController at
    // the top of selectedViewController, therefore, we run a loop to get the toppest ViewController
    private func topSelectedViewController(selectedViewController: UIViewController?) -> UIViewController? {
        var topController = selectedViewController
        var presentedViewController = topController?.presentedViewController
        while presentedViewController != nil {
            topController = presentedViewController
            presentedViewController = topController?.presentedViewController
        }
        if topController is UINavigationController {
            let navigationController = topController as? UINavigationController
            topController = navigationController?.topViewController
            return topController == nil ? navigationController : topController
        }
        return topController
    }

}
