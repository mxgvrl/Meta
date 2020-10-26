//
//  SettingsViewController.swift
//  Meta
//
//  Created by Max on 10.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController  {

    @IBOutlet weak var refButom: UIButton!
    @IBOutlet weak var setProfileImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    @IBAction func showReferenceButton(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Choose language",
            message: "English or Russian?",
            preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(
        title: "Eng",
        style: .default) {
            (alertAction) in
            let engRefVC = self.storyboard?.instantiateViewController(identifier: "EngVC")
            self.show(engRefVC!, sender: SettingsViewController())
            
        }
        let rusAction = UIAlertAction(
        title: "Rus",
        style: .default) {
            (alertAction) in
            let rusRefVC = self.storyboard?.instantiateViewController(identifier: "RusVC")
            self.show(rusRefVC!, sender: SettingsViewController())
            
        }
        alertController.addAction(defaultAction)
        alertController.addAction(rusAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(refButom)
        Utilities.styleFilledButton(setProfileImageButton)
    }
}
