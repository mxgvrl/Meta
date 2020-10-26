//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red:0.58, green:0.40, blue:0.87, alpha:1.0).cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = UIColor.init(red:0.58, green:0.40, blue:0.87, alpha:1.0)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleFilledButtonRed(_ button:UIButton) {
        button.backgroundColor = UIColor.init(red: 193/255, green: 48/255, blue: 79/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleHollowButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = CGColor(srgbRed: 0.58, green:0.40, blue:0.87, alpha:1.0)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.init(red:0.58, green:0.40, blue:0.87, alpha:1.0)
    }
    
    static func buttonBarButtonStyle(button: UIButton, image: String, title: String) {
        button.setImage(UIImage(named: image), for: UIControl.State.normal)
        button.setTitle(title, for: .normal)
        button.titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 0.0)
        button.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 0.0)
    }
}
