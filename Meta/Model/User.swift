//
//  FriendListViewController.swift
//  Meta
//
//  Created by Max on 02.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit
 class User {
    var nickname : String = ""
    var email : String = ""
    var avatar : String? = nil
    var friends : Array<User>? = nil
    var blacklist : Array<User>? = nil

    init(nickname: String,
         email: String,
         avatar: String?) {
        
        self.nickname = nickname
        self.email = email
        self.avatar = avatar
    }
}
