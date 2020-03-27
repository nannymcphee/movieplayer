//
//  CGFloat.swift
//  JJMTest
//
//  Created by Nguyên Duy on 8/1/19.
//  Copyright © 2019 Nguyên Duy. All rights reserved.
//

import UIKit
import Foundation

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    var toInt: Int {
        return Int(self)
    }
    
    var toStringRounded: String {
        return Int(self).toString()
    }
}

extension Int {
    func toString() -> String {
        return String(format: "%d", self)
    }
    
    func secondsToMinutesSeconds() -> (Int, Int) {
        return ((self % 3600) / 60, (self % 3600) % 60)
    }
    
    func toTimeString() -> String {
        let seconds = Float(self)
        let hour = Int(seconds / 3600.0)
        let min = Int(seconds.truncatingRemainder(dividingBy: 3600.0) / 60.0)
        let sec = Int(seconds.truncatingRemainder(dividingBy: 3600.0).truncatingRemainder(dividingBy: 60.0))
        return String(format: "%02d:%02d:%02d", hour, min, sec)
    }
    
    func upDown() -> String {
        var updown:String = ""
        if self > 0 {
            updown = " ▲"
        } else if self < 0 {
            updown = " ▼"
        }
        return updown
    }
}

extension Float {
    func toString(digits:Int? = nil) -> String {
        if let digits = digits {
            return String(format: "%."+digits.toString()+"f", self)
        }
        return String(format: "%f", self)
    }
    
    func upDown() -> String {
        var updown:String = ""
        if self > 0 {
            updown = " ▲"
        } else if self < 0 {
            updown = " ▼"
        }
        return updown
    }
    
    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
