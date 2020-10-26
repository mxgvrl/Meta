//
//  FriendsListViewController.swift
//  Meta
//
//  Created by Max on 04.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var friendsListTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendsListTableView = UITableView(frame: view.bounds, style: .plain)
        self.friendsListTableView.delegate = self
        self.friendsListTableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.friendsListTableView.dataSource = self
        loadArray()
        view.addSubview(friendsListTableView)
    }
    
    var array : [User] = []
    var rowIndex = 0
    
    func loadArray() {
        Firestore.firestore().collection("users")
        .document((Auth.auth().currentUser?.email!)!)
        .getDocument  { (userResult, error) in
            let userMap = userResult?.data()
        
            if (userMap?["friends"] != nil) {
                let references = userMap!["friends"] as! Array<DocumentReference>
                for reference in references {
                    reference.getDocument { (result, error) in
                        let dict = result?.data()
                        let friend = User.init(
                            nickname: dict?["nickname"] as! String,
                            email: dict?["email"] as! String,
                            avatar: dict?["avatar"] as? String)
                        self.array.append(friend)
                        self.friendsListTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
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
            let blacklistReferences = dict?["blacklist"] as? NSMutableArray
            let userRef = Firestore.firestore().collection("users").document(self.array[indexPath.row].email)
            let alertController = UIAlertController(
            title: "Removing from:",
            message: "Friends / blacklist",
            preferredStyle: .alert)
            let removeFromFriendsAction = UIAlertAction(
                title: "Remove friend",
                style: .destructive,
                handler: {removeFromFriendsAction in
                Firestore.firestore()
                    .collection("users")
                    .document((Auth.auth().currentUser?.email)!)
                    .updateData(["friends" : FieldValue.arrayRemove([userRef])])
                })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(removeFromFriendsAction)
            alertController.addAction(cancelAction)

            if blacklistReferences != nil && (blacklistReferences?.contains(userRef))! {
                let removeFromBlacklistAction = UIAlertAction(
                    title: "Unblock",
                    style: .default,
                    handler: {removeFromBlacklistAction in
                        Firestore.firestore()
                            .collection("users")
                            .document((Auth.auth().currentUser?.email)!)
                            .updateData(["blacklist" : FieldValue.arrayRemove([userRef])])
                        })
                 alertController.addAction(removeFromBlacklistAction)
            } else {
                let AddToBlacklistAction = UIAlertAction(
                    title: "Block",
                    style: .destructive,
                    handler: {AddToBlacklistAction in
                    Firestore.firestore()
                        .collection("users")
                        .document((Auth.auth().currentUser?.email)!)
                        .updateData(["blacklist" : FieldValue.arrayUnion([userRef])])
                    })
                alertController.addAction(AddToBlacklistAction)

            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
