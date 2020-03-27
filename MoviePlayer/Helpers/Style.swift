//
//  Style.swift
//  JJMTest
//
//  Created by Nguyên Duy on 8/1/19.
//  Copyright © 2019 Nguyên Duy. All rights reserved.
//

import UIKit

struct ColorScheme {
    let tint: UIColor = UIColor(red:0.15, green:0.36, blue:0.49, alpha:1.0)
    let inputTextColor = UIColor(red:0.31, green:0.49, blue:0.59, alpha:1.0)
    let text: UIColor = UIColor(red:0.09, green:0.22, blue:0.30, alpha:1.0)
    let secondaryText: UIColor = UIColor(red:0.59, green:0.66, blue:0.70, alpha:1.0)
    let pageBackground: UIColor = UIColor(red:0.97, green:0.98, blue:0.99, alpha:1.0)
    let separator: UIColor = UIColor(red:0.90, green:0.94, blue:0.96, alpha:1.0)
    let facebook: UIColor = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0)
    let placeholder: UIColor = UIColor(red:0.80, green:0.84, blue:0.87, alpha:1.0)
    let green: UIColor = UIColor(red:0.29, green:0.84, blue:0.43, alpha:1.0)
    
    let yellow = UIColor(red: 251, green: 190, blue: 37)
    let pink = UIColor(red: 249, green: 218, blue: 221)
    let lightBlue = UIColor(red: 189, green: 232, blue: 248)
    let black = UIColor(red: 29, green: 29, blue: 29)
    let memoryFreeColor = UIColor(red: 239, green: 239, blue: 244)
    let orange = UIColor(red: 241, green: 106, blue: 37)
    let red = UIColor(red: 255, green: 59, blue: 48)
    let blue = UIColor(red: 50, green: 197, blue: 255)
    let darkBlue = UIColor(red: 80, green: 99, blue: 207)
    let buttonTitleGray = UIColor(red: 169, green: 170, blue: 173)
    let segmentGrayBackground = UIColor(red: 237, green: 236, blue: 242)
    let background = UIColor(red: 246, green: 247, blue: 255)
    let defaultShadowColor = UIColor.lightGray.withAlphaComponent(0.5)
    let greenAccount: UIColor = UIColor(red: 112, green: 184, blue: 69)
    let borderColor = UIColor(red: 239, green: 239, blue: 244)
}

let colorScheme = ColorScheme()
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

struct Font {
    let bold24 = UIFont(name: "SFProText-Bold", size: 24)!
    let bold16 = UIFont(name: "SFProText-Bold", size: 16)!
    let bold8 = UIFont(name: "SFProText-Bold", size: 8)!
    let bold18 = UIFont(name: "SFProText-Bold", size: 18)!
    let bold14 = UIFont(name: "SFProText-Bold", size: 14)!
    let bold12 = UIFont(name: "SFProText-Bold", size: 12)!
    let bold10 = UIFont(name: "SFProText-Bold", size: 10)!
    let bold13 = UIFont(name: "SFProText-Bold", size: 13)!

    let regular22 = UIFont(name: "SFProText-Regular", size: 22)!
    let regular18 = UIFont(name: "SFProText-Regular", size: 18)!
    let regular16 = UIFont(name: "SFProText-Regular", size: 16)!
    let regular12 = UIFont(name: "SFProText-Regular", size: 12)!
    let regular10 = UIFont(name: "SFProText-Regular", size: 10)!
    let regular14 = UIFont(name: "SFProText-Regular", size: 14)!
    let regular13 = UIFont(name: "SFProText-Regular", size: 13)!
    
    let medium16 = UIFont(name: "SFProText-Medium", size: 16)!
    let medium14 = UIFont(name: "SFProText-Medium", size: 14)!

    let semibold14 = UIFont(name: "SFProText-SemiBold", size: 14)!
    let semibold16 = UIFont(name: "SFProText-SemiBold", size: 16)!
}

let fontScheme = Font()

func isHtml(for string: String) -> Bool {
    if string.contains("</") {
        return true
    }
    else {
        return false
    }
}
