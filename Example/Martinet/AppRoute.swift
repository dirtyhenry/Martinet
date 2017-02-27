//
//  AppRoute.swift
//  Martinet
//
//  Created by Mickaël Floc'hlay on 24/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Martinet

enum DemoMenuItem: String {
    case StereogumTopAlbums2016 = "Stereogum Top Albums 2016"
    case DemoAsyncDownloads = "Demo Async Downloads"
}

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
        let items: [DemoMenuItem] = [
            .StereogumTopAlbums2016,
            .DemoAsyncDownloads
        ]

        let rootViewController = ItemsTableViewController(items: items, configure: { cell, item in
            cell.textLabel?.text = item.rawValue
        })
        rootViewController.title = "Martinet's Menu"
        rootViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Toggle Alert", style: .plain, target: self, action: #selector(toggleAlertView(sender:)))

        rootViewController.didSelect = { menuItem in
            switch(menuItem) {
            case .StereogumTopAlbums2016:
                let stereogumTop = StereogumTop2016Presenter()
                if let stereogumVC = stereogumTop.viewController {
                    self.navigationController.modalPresentationStyle = .overCurrentContext
                    self.navigationController.pushViewController(stereogumVC, animated: true)
                }

            case .DemoAsyncDownloads:
                let demoAsyncDownloads = DemoAsyncDownloadsPresenter()
                if let demoAyncDownloadsVC = demoAsyncDownloads.viewController {
                    self.navigationController.pushViewController(demoAyncDownloadsVC, animated: true)
                }
            }
        }

        navigationController.pushViewController(rootViewController, animated: false)
    }

    func toggleAlertView(sender: Any) {
        alertController?.toggleAlertView(sender: sender)
    }
}
