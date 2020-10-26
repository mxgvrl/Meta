//
//  GetCurrentUser.swift
//  Meta
//
//  Created by Max on 04.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

func getCurrentUser(onComplete: @escaping (User) -> ()) {
    Firestore.firestore().collection("users")
        .document((Auth.auth().currentUser?.email)!)
        .getDocument  { (userResult, error) in
            let userMap = userResult?.data()
            
            onComplete(
                User.init(nickname: userMap?["nickname"] as! String, email: userMap?["email"] as! String,  avatar: userMap?["avatar"] as? String)
            )
    }
}

func getFriendsAndBlacklistCount(onComplete: @escaping ((Int, Int) -> ())) {
    Firestore.firestore().collection("users")
        .document((Auth.auth().currentUser?.email!)!)
        .getDocument { (user, error) in
            let dict = user?.data()
            let friendsReferences = dict?["friends"] as? NSMutableArray
            let blacklistReferences = dict?["blacklist"] as? NSMutableArray
            let friendsCount: Int
            let blacklistCount: Int
            if (friendsReferences == nil) {
                friendsCount = 0
            }
            else {
                friendsCount = friendsReferences!.count
            }
            if (blacklistReferences == nil) {
                blacklistCount = 0
            }
            else {
                blacklistCount = blacklistReferences!.count
            }
            
            onComplete(friendsCount, blacklistCount)
    }
}
