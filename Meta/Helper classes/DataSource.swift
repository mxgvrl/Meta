//
//  DataSource.swift
//  Meta
//
//  Created by Max on 07.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit
import Firebase

class DataSource: NSObject, UITableViewDataSource {
    var array : [User]
    override init() {
        array = []
        super.init()
        loadArray()
    }
    
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
                        
                        let friend = User.init(nickname: dict?["nickname"] as! String, email: dict?["email"] as! String,  avatar: dict?["avatar"] as? String)
                        self.array.append(friend)
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
        return cell
    }
    

}
