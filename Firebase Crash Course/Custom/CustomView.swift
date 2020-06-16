//
//  CustomView.swift
//  Firebase Crash Course
//
//  Created by mac on 6/15/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit

class CustomView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.systemIndigo.cgColor, UIColor.systemRed.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundColor = .systemIndigo
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
