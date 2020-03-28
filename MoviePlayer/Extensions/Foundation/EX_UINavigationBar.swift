//
//  EX_UINavigationBar.swift
//  joojoome_ios
//
//  Created by Nguyên Duy on 8/8/19.
//  Copyright © 2019 JOOJOOMEE. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func applyDefaultStyle() {
        self.isTranslucent = true
        self.shadowImage = UIImage()
        self.setBackgroundImage(UIImage(color: colorScheme.background), for: .default)
    }
    
    func applyClearStyle() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.barTintColor = .clear
        self.isTranslucent = true
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
    
    func changeBackgroundColor(_ color: UIColor) {
        self.isTranslucent = false
        self.shadowImage = UIImage()
        self.setBackgroundImage(UIImage(color: color), for: .default)
    }
}
