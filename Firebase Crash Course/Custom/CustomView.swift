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
    }
}

extension UIView {
    func setGradientBackground(firstColor: UIColor, secondColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
