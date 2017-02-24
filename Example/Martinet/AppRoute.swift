//
//  AppRoute.swift
//  Martinet
//
//  Created by Mickaël Floc'hlay on 24/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Martinet

class AppRoute: NSObject {
    let navigationController: UINavigationController
    var alertController: AppDomainStatusBarController?

    init(window: UIWindow) {
        navigationController = window.rootViewController as! UINavigationController
        super.init()
        self.pushMenuViewController()

        alertController = AppDomainStatusBarController(window: window)
        alertController?.setup()
    }

    func pushMenuViewController() {
        let items = ["Stereogum Top Albums 2016"]
        let rootViewController = ItemsTableViewController(items: items, configure: { cell, item in
            cell.textLabel?.text = item
        })
        rootViewController.title = "Martinet's Menu"
        rootViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Toggle Alert", style: .plain, target: self, action: #selector(toggleAlertView(sender:)))
        rootViewController.didSelect = { menuItem in
            let stereogumTop = StereogumTop2016Presenter()
            if let stereogumVC = stereogumTop.viewController {
                self.navigationController.modalPresentationStyle = .overCurrentContext
                self.navigationController.pushViewController(stereogumVC, animated: true)
            }
        }

        navigationController.pushViewController(rootViewController, animated: false)
    }

    func toggleAlertView(sender: Any) {
        alertController?.toggleAlertView(sender: sender)
    }
}
