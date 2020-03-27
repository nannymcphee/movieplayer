//
//  Helper.swift
//  stroudhome
//
//  Created by cuong.truong on 6/29/18.
//  Copyright © 2018 Dat Nguyen. All rights reserved.
//

import UIKit

public class Helper {
    
    static var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    static func addSubview(subView: UIView, toView parentView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    static func setupStatusBar(style: UIStatusBarStyle, backgroundColor: UIColor) {
//        UIApplication.shared.statusBarStyle = style
        UIApplication.shared.statusBarView?.backgroundColor = backgroundColor
    }
    
    static func addTintView(toView: UIView) {
        let tintView = UIView()
        
        tintView.backgroundColor = UIColor(red: 57.0/255.0, green: 46.0/255.0, blue: 44.0/255.0, alpha: 0.5)
        tintView.frame = toView.bounds
        
        Helper.addSubview(subView: tintView, toView: toView)
    }
    
    static func hexStringToUIColor (hex:String?, alpha: Double) -> UIColor? {
        if hex != nil {
            var cString:String = hex!.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }
            
            if ((cString.count) != 6) {
                return UIColor.gray
            }
            
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(alpha)
            )
        } else {
            return nil
        }
    }
}

extension UIApplication {
    var statusBarView: UIView? {
//        if responds(to: Selector("statusBar")) {
//            return value(forKey: "statusBar") as? UIView
//        }
//        return nil
        
        if #available(iOS 13.0, *) {
            let tag = 38482458385
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag
                
                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
        
    }
}
