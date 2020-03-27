//
//  EX_String.swift
//  JJMTest
//
//  Created by Nguyên Duy on 8/1/19.
//  Copyright © 2019 Nguyên Duy. All rights reserved.
//

import UIKit
import Foundation

extension String {
    func convertDate(dateFormat: String, finalFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        
        if let dateInLocal = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = finalFormat
            return dateFormatter.string(from: dateInLocal)
        } else {
            return "NA"
        }
    }
    
    func htmlAttributedString(fontSize: CGFloat = 16.0, completion: ((NSAttributedString?) -> Void)?) {
        let fontName = "SFProText-Regular"
        let dynamicFontSize = 16
        let string = self.appending(String(format: "<style>body{font-family: '%@'; font-size:%fpx;}</style>", fontName, dynamicFontSize))
        DispatchQueue.global(qos: .background).async {
            guard let data = string.data(using: .utf16, allowLossyConversion: false) else { return }
            
            guard let html = try? NSMutableAttributedString (
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil) else { return }
            
            completion?(html)
        }
    }
    
    func createAttributedString(textToStyle: String, attributes: [NSAttributedString.Key : Any], styledAttributes: [NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        let attributedResultText = NSMutableAttributedString(string: self, attributes: attributes)
        let range = (self as NSString).range(of: textToStyle)
        
        attributedResultText.addAttributes(styledAttributes, range: range)
        
        return attributedResultText
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: self)
    }
    
    func encodeUrl() -> String {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    func decodeUrl() -> String {
        return self.removingPercentEncoding!
    }
    
    func lineEnter() -> String {
        return self.replacingOccurrences(of: String("\\r"), with: "").replacingOccurrences(of: String("\\n"), with: "\n")
    }
    
    func alert(_ viewController:UIViewController,
               buttonCompletion: ((UIAlertAction) -> Void)? = nil,
               buttonCancel: ((UIAlertAction) -> Void)? = nil) {
        var title:String? = nil
        var msg:String = self
        
        let temp = self.components(separatedBy: "|||")
        if temp.count > 1 {
            title = temp[0]
            msg = temp[1]
        }
        let alertController = UIAlertController(title: title, message: msg.lineEnter(), preferredStyle: UIAlertController.Style.alert)
        if buttonCompletion != nil && buttonCancel != nil {
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: buttonCompletion)
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: buttonCancel)
            alertController.addAction(okButton)
            alertController.addAction(cancelButton)
            
        } else {
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: buttonCompletion)
            alertController.addAction(cancelButton)
        }
        
        viewController.present(alertController,animated: true,completion: nil)
    }
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }
    
    func toDate(_ format:String!) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.date(from: self)
        return date ?? nil
    }
    
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    
    func validateEmail() -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
    
    
    func validatePassword() -> Bool {
        
//        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8}$"
        let passwordRegEx = "^(?=.*[a-zA-Z])(?=.*[0-9]).{8,13}$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
    
    var comma: String {
        get {
            let _val = NSNumber(value: Float(self)!)
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let formattedNumber = numberFormatter.string(from: _val) {
                return formattedNumber
            }
            
            return String(format: "%@", _val)
        }
    }
    
    func toInt() -> Int {
        if self == "" {
            return 0
        }
        return Int(self)!
    }
    
    
    func toDouble() -> Double {
        if self == "" {
            return 0.0
        }
        return Double(self)!
    }
    
    func toFloat() -> Float {
        if self == "" {
            return 0.0
        }
        return Float(self)!
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        
        return String(format: "%02d : %02d", minutes, seconds)
    }
}

