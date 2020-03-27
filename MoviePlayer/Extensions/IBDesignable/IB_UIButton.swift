//
//  IB_UIButton.swift
//  JJMTest
//
//  Created by Nguyên Duy on 8/1/19.
//  Copyright © 2019 Nguyên Duy. All rights reserved.
//

import UIKit
import Foundation

private var __value = [UIButton: String]()

@IBDesignable extension UIButton {
    
    @IBInspectable var value: String {
        get {
            guard let l = __value[self] else {
                return ""
            }
            return l
        }
        set {
            __value[self] = newValue
        }
    }
}

extension UIButton {
    func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        let imageSize: CGSize = imageView!.image!.size
        titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + padding), right: 0.0)
        let labelString = NSString(string: titleLabel!.text!)
        let titleSize = labelString.size(withAttributes: [kCTFontAttributeName as NSAttributedString.Key: titleLabel!.font])
        self.imageEdgeInsets = UIEdgeInsets.init(top: -(titleSize.height + padding), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets.init(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
    
//    func alignTabbarImageAndTitleVertically(padding: CGFloat = 6.0) {
//        let defaultSize = AppConstants.tabBarIconSize
//        let targetSize: CGSize = Helper.dynamicSizeImage(defaultSize: defaultSize)
//        let imageSize: CGSize = targetSize
//        titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + padding), right: 0.0)
//        let labelString = NSString(string: titleLabel!.text!)
//        let titleSize = labelString.size(withAttributes: [kCTFontAttributeName as NSAttributedString.Key: titleLabel!.font])
//        self.imageEdgeInsets = UIEdgeInsets.init(top: -(titleSize.height + padding), left: 0.0, bottom: 0.0, right: -titleSize.width)
//        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
//        self.contentEdgeInsets = UIEdgeInsets.init(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
//    }
}
