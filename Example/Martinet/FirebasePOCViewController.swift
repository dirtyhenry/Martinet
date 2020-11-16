//
//  FirebasePOCViewController.swift
//  Martinet
//
//  Created by Mickaël Floc'hlay on 20/03/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseDatabase
import ObjectMapper
import PromiseKit

typealias FirebaseObject = Any

protocol Firebasable: Mappable {
    var uid: String? { get set }
}

struct Record {
    var uid: String?
    var name: String?
    var release: Date?
    var rating: Int?
    var cover: URL?
    var purchased: Bool?
    var songs: [String]?
}

extension Record: Firebasable {
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        name <- map["name"]
        release <- (map["releaseDate"], DateTransform())
        rating <- map["rating"]
        cover <- (map["coverURL"], URLTransform())
        purchased <- map["purcharsed"]
        songs <- map["songs"]
    }
}

protocol DataPathDescriptor {
    var path: String { get }
}

enum FirebaseDomainEntity: DataPathDescriptor {
    case recordsRoot
    case record(uid: String)

    var path: String {
        switch self {
        case .recordsRoot:
            return "records"
        case .record(let uid):
            return "records/\(uid)"
        }
    }
}

class FirebasePOCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createAction(_ sender: Any) {
        print("Create")

        var record = Record()
        record.name = "Sgt. Pepper"
        record.release = Date()
        record.rating = 3
        record.cover = URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/1a/Sgt_Pepper%27s_Lonely_Hearts_Club_Band.jpg")
        record.purchased = true
        record.songs = [
            "Sgt. Pepper's Lonely Hearts Club Band",
            "With a Little Help from My Friends",
            "Lucy in the Sky with Diamonds",
            "Getting Better",
            "Fixing a Hole",
            "She's Leaving Home",
            "Being for the Benefit of Mr. Kite!",
        ]
        
        self.create(atPath: FirebaseDomainEntity.recordsRoot, value: record)
            .done { result in
                print(result)
            }
            .catch { error in
                self.presentError(error)
        }
    }

    @IBAction func readAction(_ sender: Any) {
        print("Read")
    }

    @IBAction func updateAction(_ sender: Any) {
        print("Update")
    }

    @IBAction func deleteAction(_ sender: Any) {
        print("Delete")
    }

    // MARK: - Firebase Tools

    func create<A: Firebasable>(atPath pathDescriptor: DataPathDescriptor, value: A) -> Promise<A> {
        let ref = Database.database().reference(withPath: pathDescriptor.path)
        let newObjectID = ref.childByAutoId().key
        let updatePath = "\(pathDescriptor.path)/\(newObjectID)"
        return Promise<A> { seal in
            update(atPathValue: updatePath, value: value.toJSON()) { error in
                if let error = error {
                    seal.reject(error)
                } else {
                    var result = value
                    result.uid = newObjectID
                    seal.fulfill(result)
                }
            }
        }
    }

    func update(atPath pathDescriptor: DataPathDescriptor, value: FirebaseObject, completion: @escaping (Error?) -> ()) {
        let pathValue = pathDescriptor.path
        update(atPathValue: pathValue, value: value, completion: completion)
    }

    internal func update(atPathValue pathValue: String, value: FirebaseObject, completion: @escaping (Error?) -> ()) {
        let ref = Database.database().reference()

        let updates = [pathValue: value]

        ref.updateChildValues(updates) { error, ref in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    func presentError(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
