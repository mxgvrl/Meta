//
//  ChatRoomViewController.swift
//  Meta
//
//  Created by Max on 14.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    public var room: ChatRoom? = nil
    var messages: Array<Message>? = nil
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        var text = messageTextField.text ?? ""
        if (!text.trimmingCharacters(in: .whitespaces).isEmpty) {
            text = crypt(text: text, key: room!.id)
            Firestore.firestore().collection("chat_rooms")
                .document(room!.id)
                .collection("messages")
                .addDocument(data: ["text": text, "date": Date(), "senderEmail": Auth.auth().currentUser!.email!])
        }
        messageTextField.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userEmailLabel.text = room!.title
        
        Firestore.firestore().collection("chat_rooms")
        .document(room!.id)
        .collection("messages")
        .addSnapshotListener { (snapshot, e) in
            let documents = snapshot!.documents
            var messages: Array<Message> = []
            for document in documents {
                let date = (document.get("date") as! Timestamp).dateValue()
                let text = self.crypt(text: document.get("text") as! String, key: self.room!.id)
                let message = Message(id: document.documentID, text: text, date: date, senderEmail: document.get("senderEmail") as! String)
                messages.append(message)
            }
            self.messages = messages.sorted(by: { (mes1, mes2) -> Bool in
                mes1.date < mes2.date
            })
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        cell.textLabel?.text = self.messages![indexPath.row].text
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ChatRoomViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatRoomViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.hideKeyboardWhenTappedAround()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardFrame.height - keyboardFrame.height / 4
        }
    }
        
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let messagesViewController = self.storyboard?.instantiateViewController(identifier: "chatsVC")
        
        self.view.window?.rootViewController = messagesViewController
        self.view.window?.makeKeyAndVisible()

    }
    
    func crypt(text: String, key: String) -> String {
        let intKey = getIntKey(key: key)
        return String(text.unicodeScalars.map { Character(UnicodeScalar((Int($0.value) ^ intKey))!) })
    }
    
    func getIntKey(key: String) -> Int {
        key.unicodeScalars.map { Int($0.value) }.reduce(0, +) / key.count
    }

}
