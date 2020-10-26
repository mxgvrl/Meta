//
//  ViewController.swift
//  Meta
//
//  Created by Max on 15.11.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        assignbackground()
        if Auth.auth().currentUser != nil {
           let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? ViewController
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
        }
    }
    
    func setUpElements() {
            Utilities.styleFilledButton(signUpButton)
            Utilities.styleHollowButton(loginButton)
    }


}

