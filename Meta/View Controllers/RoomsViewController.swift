//
//  MessagesViewController.swift
//  Meta
//
//  Created by Max on 09.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

//class TableViewCells: UITableViewCell {
//
//    @IBOutlet weak var emailLable: UILabel!
//}

class RoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var rooms: [ChatRoom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        Firestore.firestore().collection("users")
            .document((Auth.auth().currentUser?.email)!)
            .getDocument { (snapshot, e) in
                if (snapshot?.get("chat_rooms") != nil) {
                    let chats = snapshot?.get("chat_rooms") as! Array<DocumentReference>
                    for chat in chats {
                        chat.getDocument { (chatSnapshot, e) in
                            self.rooms.append(ChatRoom(title: chatSnapshot?.get("title") as! String, id: chatSnapshot!.documentID))
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        self.navigationItem.title = "Messages"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.delegate = self
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        //view.addSubview(chatListTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.textLabel?.text = self.rooms[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chat = ChatViewController()
        chat.room = self.rooms[indexPath.row]
        self.show(chat, sender: self)
    }
}
