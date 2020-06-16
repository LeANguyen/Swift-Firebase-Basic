//
//  Custom.swift
//  Firebase Crash Course
//
//  Created by mac on 6/15/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit

class CustomIndicator: UIActivityIndicatorView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHidden = true
        self.style = .large
        self.color = .white
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
