//
//  LoginViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var HaveNoAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        self.hideKeyboardWhenTappedAround()
        assignbackground()
    }
    
    func setUpElements() {
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
            let email = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               
               Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                   if error != nil {
                       self.showError(error!.localizedDescription)
                   }
                   else if Auth.auth().currentUser?.isEmailVerified ?? false {
                       let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? UITabBarController
                       
                       self.view.window?.rootViewController = homeViewController
                       self.view.window?.makeKeyAndVisible()
                   }
                   else {
                    self.showError("Email isn't verified!")
                   }
               }
           }
    
    func showError(_ message:String) {
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                         
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
    }
}

 extension UIViewController {
    func assignbackground(){
//        let background = UIImage(named: "background")
//
//        var imageView : UIImageView!
//        imageView = UIImageView(frame: view.bounds)
//        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.image = background
//        imageView.center = view.center
//        view.addSubview(imageView)
//        self.view.sendSubviewToBack(imageView)
    }
}
