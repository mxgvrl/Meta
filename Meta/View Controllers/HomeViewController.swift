//
//  HomeViewController.swift
//  Meta
//
//  Created by Max on 15.11.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var viewFriendsListButton: UIButton!
    @IBOutlet weak var viewBlacklistButton: UIButton!
    @IBOutlet weak var changeUsernameButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var blackListLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser { user in
            self.usernameLabel.text = user.nickname
            self.emailLabel.text = user.email
            if (user.avatar != nil) {
                Storage.storage().reference(withPath: user.avatar!).getData(maxSize: 5 * 1024 * 1024) { (data, e) in
                    if e != nil {
                        print("Error")
                    }
                    else {
                        let image = UIImage(data: data!)
                        self.avatar.image = image
                    }
                }
            }
        }
        
        Utilities.styleFilledButtonRed(logOutButton)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        getFriendsAndBlacklistCount { (friends, blacklist) in
            self.friendsLabel.text = String(friends)
            self.blackListLabel.text = String(blacklist)
        }
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }

    @IBAction func changeUsernameTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Change username", message: "Input your name here", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
          //let textField = alert.textFields![0] as UITextField
            let displayName = alert.textFields![0].text
            Firestore.firestore().collection("users")
                .document((Auth.auth().currentUser?.email)!)
                .updateData(["nickname" : displayName])
            self.usernameLabel.text = displayName
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new name"
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(_ message:String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func changePasswordTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Change password", message: "Input your new password here", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
            let password = alert.textFields![0].text
            Auth.auth().currentUser?.updatePassword(to: password!) { (error) in
                if error != nil {
                self.showError("Error saving user data")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new password"
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
