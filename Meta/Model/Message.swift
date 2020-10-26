//
//  Message.swift
//  Meta
//
//  Created by Max on 15.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import Foundation

class Message {
    
    init(id: String, text: String, date: Date, senderEmail: String) {
        self.id = id
        self.text = text
        self.date = date
        self.senderEmail = senderEmail
    }
    
    var id: String
    var text: String
    var date: Date
    var senderEmail: String
    
}
