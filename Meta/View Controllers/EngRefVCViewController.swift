//
//  EngRefVCViewController.swift
//  Meta
//
//  Created by Max on 17.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit

class EngRefVCViewController: UIViewController {

    @IBOutlet weak var refLable: UILabel!
    
    let lableText = """
    Meta is a messenger that is developed by 3 people as part of the laboratory work. The idea is simple: Provide convenient interaction for people, regardless of platform. I can conveniently interact with each other.

    For whom is it?

    Our product is universal. It can be used by children, adolescents, adults, regardless of their hobby or professional activity, because our main task is to make the product affordable and convenient for everyone.

    Why exactly Meta

    Unlike competitors, we provide our services completely free of charge without any restrictions. We will take means of subsistence from voluntary donations and advertising

    What can you do

    Using this application you can:
    Send messages;
    Add users to friends;
    Create your friends / rooms lists;
    change visual design
    Sending Messages
    1) Choose room in room tab;
    2) Click on it;
    3) Input text in the input panel;
    4) Click on button 'send'.
"""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refLable.text = lableText
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }
    
    @IBAction func backButton(_ sender: Any) {
        let engRefVC = self.storyboard?.instantiateViewController(identifier: "Settings")
        
        self.view.window?.rootViewController = engRefVC
        self.view.window?.makeKeyAndVisible()
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
