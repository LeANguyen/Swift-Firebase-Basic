//
//  CustomLabel.swift
//  Firebase Crash Course
//
//  Created by mac on 6/15/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = .white
        self.font = UIFont(name: "ArialRoundedMTBold", size: 30)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
