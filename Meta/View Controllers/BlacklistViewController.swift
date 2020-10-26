//
//  BlacklistViewController.swift
//  Meta
//
//  Created by Max on 07.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class BlacklistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var blacklistTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blacklistTableView = UITableView(frame: view.bounds, style: .plain)
        self.blacklistTableView.delegate = self
        self.blacklistTableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.blacklistTableView.dataSource = self
        loadArray()
        view.addSubview(blacklistTableView)
    }
    
    var array : [User] = []
    
    func loadArray() {
        Firestore.firestore().collection("users")
        .document((Auth.auth().currentUser?.email!)!)
        .getDocument  { (userResult, error) in
            let userMap = userResult?.data()
        
            if (userMap?["blacklist"] != nil) {
                let references = userMap!["blacklist"] as! Array<DocumentReference>
                for reference in references {
                    reference.getDocument { (result, error) in
                        let dict = result?.data()
                        
                        let friend = User.init(
                            nickname: dict?["nickname"] as! String,
                            email: dict?["email"] as! String,
                            avatar: dict?["avatar"] as? String)
                        self.array.append(friend)
                        self.blacklistTableView.reloadData()
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
}
