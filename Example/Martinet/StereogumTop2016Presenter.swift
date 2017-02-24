//
//  StereogumTop2016Presenter.swift
//  Martinet
//
//  Created by Mickaël Floc'hlay on 24/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Martinet

class StereogumTop2016Presenter {
    var albums: [Any] = []
    var viewController: ItemsTableViewController<Any, UITableViewCell>?

    init() {
        do {
            if let url = Bundle.main.url(forResource: "2016-stereogum-best-albums", withExtension: "json") {
                let jsonData = try Data(contentsOf: url)
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData)
                albums = jsonResult as! [Any]
                viewController = ItemsTableViewController(items: albums, configure: { cell, item in
                    let album = item as! [String: Any]
                    let rank = album["Rank"] as! Int
                    let artist = album["Artist"] as! String
                    cell.textLabel?.text = "\(rank). \(artist)"
                    cell.detailTextLabel?.text = "\(rank). \(artist)"
                })
                viewController?.title = "Stereogum Top Albums 2016"
            }
        } catch {
            debugPrint("JSON parsing failed")
        }
    }
}
