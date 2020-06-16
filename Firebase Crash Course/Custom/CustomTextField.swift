//
//  CustomTextField.swift
//  Firebase Crash Course
//
//  Created by mac on 6/15/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftViewMode = UITextField.ViewMode.always
        self.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        self.backgroundColor = UIColor.clear
        self.tintColor = .white
        self.textColor = .white
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width - 40, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
