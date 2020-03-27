//
//  EX_CALayer.swift
//  JJMTest
//
//  Created by Nguyên Duy on 8/1/19.
//  Copyright © 2019 Nguyên Duy. All rights reserved.
//

import UIKit

extension CALayer {
    func dropShadowWithRoundedCorners(
        radius: CGFloat = 10,
        shadowColor: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1),
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 20,
        blur: CGFloat = 40,
        spread: CGFloat = 0)
        
    {
        cornerRadius = radius
        masksToBounds = false
        self.shadowColor = shadowColor.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
