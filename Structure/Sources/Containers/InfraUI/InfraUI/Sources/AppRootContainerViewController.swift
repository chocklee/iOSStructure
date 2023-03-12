//
//  AppRootContainerViewController.swift
//  InfraUI
//
//  Created by Changhao Li on 2023/3/9.
//

import Foundation
import UIKit

public final class AppRootContainerViewController: UIViewController {

    public weak var childViewController: UIViewController?

    public override var childForStatusBarStyle: UIViewController? {
        return children.first
    }

    public override var childForStatusBarHidden: UIViewController? {
        return children.first
    }

    // MARK: Kept after refactor

    static let transitionDuration = 0.25

    // MARK: Public Method

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func replaceChild(with viewController: UIViewController,
                             animationConfig: ((UIViewController) -> Void)? = nil,
                             extraAnimationDestinationConfig: ((UIViewController) -> Void)? = nil,
                             completion: ((Bool) -> Void)? = nil) {

        // Dismiss any modal view controllers that may be showing prior to swapping
        // out to the login view controller and killing the mainViewController
        AppRouterDispatcher.shared.dismissModalViewControllers(false, completion: nil)

        // Create a new login view controller
        let newChildViewController = viewController
        newChildViewController.view.frame = view.bounds
        guard let currentViewController = childViewController else {
            childViewController = newChildViewController
            addChild(newChildViewController)
            view.addSubview(newChildViewController.view)
            newChildViewController.didMove(toParent: self)
            completion?(true)
            return
        }
        currentViewController.willMove(toParent: nil)
        childViewController = newChildViewController
        addChild(newChildViewController)

        let transitionBlock: (Bool) -> Void = { [weak self] finished in
            guard let self = self else {
                return
            }
            currentViewController.removeFromParent()
            newChildViewController.didMove(toParent: self)
            if let completion = completion {
                completion(finished)
            }
        }

        animationConfig?(newChildViewController)

        let targetFrame = view.bounds
        transition(
            from: currentViewController,
            to: newChildViewController,
            duration: Self.transitionDuration,
            options: []) {
                newChildViewController.view.frame = targetFrame
                extraAnimationDestinationConfig?(newChildViewController)
            } completion: { finished in
                transitionBlock(finished)
            }
    }
}
