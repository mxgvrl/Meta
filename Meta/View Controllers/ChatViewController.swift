//
//  ChatViewController.swift
//  Meta
//
//  Created by Max on 15.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView

class Sender: SenderType {
    internal init(senderId: String, displayName: String) {
        self.senderId = senderId
        self.displayName = displayName
    }
    var senderId: String
    var displayName: String
}

class MessageTypeImpl: MessageType {
    internal init(sender: SenderType, sentDate: Date, kind: MessageKind) {
        self.sender = sender
        self.sentDate = sentDate
        self.kind = kind
    }
    
    var sender: SenderType
    var messageId: String = ""
    var sentDate: Date
    var kind: MessageKind
}

class ChatViewController: MessageKit.MessagesViewController, MessagesDataSource, MessagesDisplayDelegate, MessageCellDelegate, MessagesLayoutDelegate, InputBarAccessoryViewDelegate {
    
    var room: ChatRoom? = nil
    var messages: Array<Message>? = nil
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func loadView() {
        super.loadView()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.center = CGPoint(x: view.frame.width/2, y: 100)
        toolbar.backgroundColor = UIColor.orange
    
        let cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: nil)
        toolbar.items = [cancel]
        view.addSubview(toolbar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
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
            self.messagesCollectionView.reloadData()
        }
    }
    
    func currentSender() -> SenderType {
        let email = Auth.auth().currentUser!.email!
        return Sender(senderId: email, displayName: email)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let message = messages![indexPath.section]
        return MessageTypeImpl(sender: Sender(senderId: message.senderEmail, displayName: message.senderEmail), sentDate: message.date, kind: MessageKind.text(message.text))
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages?.count ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .yellow
        messageInputBar.sendButton.setTitleColor(.purple, for: .normal)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.inputTextView.placeholder = "Input ur message"
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        let cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: nil)
        setToolbarItems([cancel], animated: true)
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func crypt(text: String, key: String) -> String {
        let intKey = getIntKey(key: key)
        return String(text.unicodeScalars.map { Character(UnicodeScalar((Int($0.value) ^ intKey))!) })
    }
    
    func getIntKey(key: String) -> Int {
        key.unicodeScalars.map { Int($0.value) }.reduce(0, +) / key.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        var text = messageInputBar.inputTextView.text ?? ""
        messageInputBar.tintColor = UIColor.black
        if (!text.trimmingCharacters(in: .whitespaces).isEmpty) {
            text = crypt(text: text, key: room!.id)
            Firestore.firestore().collection("chat_rooms")
                .document(room!.id)
                .collection("messages")
                .addDocument(data: ["text": text, "date": Date(), "senderEmail": Auth.auth().currentUser!.email!])
        }
        messageInputBar.inputTextView.text = ""
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        let index = messagesCollectionView.indexPath(for: cell)!.section
        let message = messages![index]
        if (message.senderEmail == Auth.auth().currentUser!.email!) {
        let alertController = UIAlertController(
        title: "Removing message",
        message: "Remove?",
        preferredStyle: .alert)
        let removeFromFriendsAction = UIAlertAction(
            title: "Remove",
            style: .destructive,
            handler: {removeFromFriendsAction in

                Firestore.firestore().collection("chat_rooms")
                    .document(self.room!.id)
                    .collection("messages")
                    .document(message.id)
                    .delete()
                
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(removeFromFriendsAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
