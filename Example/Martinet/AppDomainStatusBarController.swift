//
//  AppDomainStatusBarController.swift
//  Martinet
//
//  Created by Mickaël Floc'hlay on 20/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class AppDomainStatusBarController: NSObject {
    let window: UIWindow
    let statusBarHeight: CGFloat
    let statusBarHeightWhenClosed: CGFloat = 20.0
    let animationDuration: TimeInterval = 0.300

    var alertViewController: UIViewController?
    var contentViewController: UIViewController?

    var referenceFrame: CGRect?
    var alertIsVisible: Bool

    init(window: UIWindow, statusBarHeight: CGFloat = 40.0) {
        self.window = window
        self.statusBarHeight = statusBarHeight
        self.alertIsVisible = false
    }

    func setup() {
        guard let oldRootViewController = window.rootViewController else { return }

        // Keep references of stuff
        let mainViewFrame = oldRootViewController.view.frame
        self.referenceFrame = mainViewFrame
        self.alertViewController = createAlertViewController(frame: mainViewFrame)
        self.contentViewController = oldRootViewController

        // Switch new root view controller
        let newRootViewController = UIViewController()
        add(childViewController: alertViewController!, toParentViewController: newRootViewController)
        add(childViewController: oldRootViewController, toParentViewController: newRootViewController)
        window.rootViewController = newRootViewController

        // Resize views
        hideAlertView(force: true)
    }

    func showAlertView() {
        if !alertIsVisible {
            alertIsVisible = true
            resizeFrames(statusBarHeight: statusBarHeight)
        }
    }

    func hideAlertView(force: Bool = false) {
        if alertIsVisible || force {
            alertIsVisible = false
            resizeFrames(statusBarHeight: statusBarHeightWhenClosed)
        }
    }

    func toggleAlertView(sender: Any) {
        alertIsVisible ? hideAlertView() : showAlertView()
    }

    private func resizeFrames(statusBarHeight: CGFloat) {
        guard let referenceFrame = referenceFrame else { return }

        UIView.animate(withDuration: animationDuration) {
            self.alertViewController?.view.frame = CGRect(x: 0.0, y: 0.0, width: referenceFrame.width, height: statusBarHeight)
            self.contentViewController?.view.frame = CGRect(x: 0.0, y: statusBarHeight, width: referenceFrame.width, height: referenceFrame.height - statusBarHeight)
        }
    }

    private func createAlertViewController(frame: CGRect) -> UIViewController {
        let alertViewController = UIViewController()
        let alertView = UIView(frame: frame)
        alertView.backgroundColor = .orange
        alertViewController.view.addSubview(alertView)
        return alertViewController
    }

    private func add(childViewController child: UIViewController, toParentViewController parent: UIViewController) {
        parent.addChildViewController(child)
        parent.view.addSubview(child.view)
        child.didMove(toParentViewController: parent)
    }
}
