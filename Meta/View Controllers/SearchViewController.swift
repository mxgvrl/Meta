//
//  SearchViewController.swift
//  Meta
//
//  Created by Max on 07.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class TableViewCell: UITableViewCell {
    
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchListTableView.dataSource = self
        self.searchListTableView.delegate = self
        self.searchListTableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        loadArray()
    }
    
    var array : [User] = []
    
    func loadArray() {
        Firestore.firestore().collection("users")
        .getDocuments{ (snapshot, error) in
            for document in snapshot!.documents {
                let nickname = document["nickname"]
                let email = document["email"]
                let avatar = document["avatar"]
                let user = User.init(nickname: nickname as! String, email: email as! String,  avatar: avatar as? String)
                self.array.append(user)
                self.searchListTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        as! TableViewCell
        cell.textLabel?.text = self.array[indexPath.row].email
        if (self.array[indexPath.row].avatar) != nil
        {
            Storage.storage().reference(withPath: self.array[indexPath.row].avatar!).getData(maxSize: 1 * 1024 * 1024) { (data, e) in
                if e != nil {
                    print("Error")
                }
                else {
                    cell.imageView?.contentMode = .scaleAspectFill
                    let image = UIImage(data: data!)
                    cell.imageView?.image = image
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Firestore.firestore().collection("users")
        .document((Auth.auth().currentUser?.email!)!)
        .getDocument { (user, error) in
            let dict = user?.data()
            let friendsReferences = dict?["friends"] as? NSMutableArray
            let userRef = Firestore.firestore().collection("users").document(self.array[indexPath.row].email)
            if friendsReferences != nil && ((friendsReferences?
                .contains(userRef))!) {
                let alertController = UIAlertController(
                    title: "Removing from friends",
                    message: "Remove from friends?",
                    preferredStyle: .alert)
                let defaultAction = UIAlertAction(
                title: "Ok",
                style: .destructive) {
                    (alertAction) in
                    Firestore.firestore()
                        .collection("users")
                        .document((Auth.auth().currentUser?.email)!)
                        .updateData(["friends" : FieldValue.arrayRemove([userRef])])
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(
                    title: "Adding to friends",
                    message: "Add user to friends?",
                    preferredStyle: .actionSheet)
                let removeFromBlacklistAction = UIAlertAction(
                title: "Ok",
                style: .default) {
                    (alertAction) in
                    Firestore.firestore()
                        .collection("users")
                        .document((Auth.auth().currentUser?.email)!)
                        .updateData(["friends" : FieldValue.arrayUnion([userRef])])
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(removeFromBlacklistAction)
                alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

