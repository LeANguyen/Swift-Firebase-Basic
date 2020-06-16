//
//  CustomButton.swift
//  Firebase Crash Course
//
//  Created by mac on 6/15/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = .white
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.frame.size.height = 50
        self.contentEdgeInsets.top = 15
        self.contentEdgeInsets.bottom = 15
        self.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
