//
//  UIView+Extension.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/4/2.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow(shadowColor color: CGColor, offset: CGSize, shadowRadius: CGFloat, opacity: Float) {
        clipsToBounds = true
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shadowColor = color
        layer.shadowOffset = offset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}
