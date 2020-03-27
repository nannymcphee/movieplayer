//
//  Device.swift
//  joojoome_ios
//
//  Created by Nguyên Duy on 8/5/19.
//  Copyright © 2019 JOOJOOMEE. All rights reserved.
//

import Foundation
import UIKit

struct Device {
    // iDevice detection code
    static let isIpad             = UIDevice.current.userInterfaceIdiom == .pad
    static let isIphone           = UIDevice.current.userInterfaceIdiom == .phone
    static let isRetina           = UIScreen.main.scale >= 2.0
    
    static let screenWidth        = Int(UIScreen.main.bounds.size.width)
    static let screenHeight       = Int(UIScreen.main.bounds.size.height)
    static let screenMaxLength   = Int(max(screenWidth, screenHeight))
    static let screenMinLength   = Int(min(screenWidth, screenHeight))
    
    static let isIphone4OrLess = isIphone && screenMaxLength  < 568
    static let isIphone5OrLess   = isIphone && screenMaxLength <= 568
    static let isIphone6OrLess = isIphone && screenMaxLength <= 736
    static let isIphone5        = isIphone && screenMaxLength == 568
    static let isIphone6         = isIphone && screenMaxLength == 736
    static let isIphone6P        = isIphone && screenMaxLength == 736
    static let isIphoneX         = isIphone && screenMaxLength == 812
    static let isIphoneXOrAbove = isIphone && screenMaxLength >= 812
    
    static var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}
