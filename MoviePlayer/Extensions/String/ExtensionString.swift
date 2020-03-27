//
//  ExtensionString.swift
//  joojoome_ios
//
//  Created by MacBookj on 8/2/19.
//  Copyright © 2019 JOOJOOMEE. All rights reserved.
//

import Foundation
import UIKit


extension String {
    //Check contain letters
    /// Allows only `a-zA-Z`
    public var isContainLetterAlphabec: Bool {
        guard !isEmpty else {
            return false
        }
        let allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let characterSet = CharacterSet(charactersIn: allowed)
        guard rangeOfCharacter(from: characterSet.inverted) == nil else {
            return false
        }
        return true
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
}
