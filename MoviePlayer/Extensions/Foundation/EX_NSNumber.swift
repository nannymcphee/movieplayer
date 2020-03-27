//
//  EX_NSNumber.swift
//  JJMTest
//
//  Created by Nguyên Duy on 8/1/19.
//  Copyright © 2019 Nguyên Duy. All rights reserved.
//

import UIKit
import Foundation

extension NSNumber {
    var comma: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let formattedNumber = numberFormatter.string(from: self) {
                return formattedNumber
            }
            
            return String(format: "%@", self)
        }
    }
}
