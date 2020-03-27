////
////  EX_UserDeafults.swift
////  JJMTest
////
////  Created by Nguyên Duy on 4/28/19.
////  Copyright © 2019 Nguyên Duy. All rights reserved.
////
//

//import Foundation
//import UIKit
//
//extension UserDefaults {
//    // MARK: - shouldShowMenuGuide
//    func setShouldShowMenuGuide(value: Bool) {
//        set(value, forKey: DefineUserDefaults.guidePopup.rawValue + UIApplication.shared.applicationBuild())
//    }
//    
//    func shouldShowMenuGuide() -> Bool {
//        return bool(forKey: DefineUserDefaults.guidePopup.rawValue + UIApplication.shared.applicationBuild())
//    }
//    
//    func setShouldShowPainReliefGuide(value: Bool) {
//        set(value, forKey: DefineUserDefaults.painReliefPopup.rawValue + UIApplication.shared.applicationBuild())
//    }
//    
//    func setShouldShowPreventPaintingGuide(value: Bool) {
//        set(value, forKey: DefineUserDefaults.painPreventPaintingPopup.rawValue + UIApplication.shared.applicationBuild())
//    }
//    
//    func shouldShowPainReliefGuide() -> Bool {
//        return bool(forKey: DefineUserDefaults.painReliefPopup.rawValue + UIApplication.shared.applicationBuild())
//
//    }
//    
//    func shouldShowPreventPaintingGuide() -> Bool {
//        return bool(forKey: DefineUserDefaults.painPreventPaintingPopup.rawValue + UIApplication.shared.applicationBuild())
//    }
//    
//    func firstLaunchDate() -> Date? {
//        return self.object(forKey: DefineUserDefaults.firstLaunchDate.rawValue) as? Date
//    }
//    
//    
//    func menuUpdated() -> Bool {
//        return bool(forKey: DefineUserDefaults.menuUpdated.rawValue)
//    }
//    
//    // MARK: - isSharedData
//    func setIsAutoLoginOn(value: Bool) {
//        set(value, forKey: DefineUserDefaults.autoLoginOn.rawValue)
//    }
//    
//    func isAutoLoginOn() -> Bool {
//        return bool(forKey: DefineUserDefaults.autoLoginOn.rawValue)
//    }
//    
//    // MARK: - isSharedData
//    func setMenuUpdated(value: Bool) {
//        set(value, forKey: DefineUserDefaults.menuUpdated.rawValue)
//    }
//    
//    func setFirstLaunchDate(_ date: Date) {
////        set(date, forKey: DefineUserDefaults.firstLaunchDate.rawValue)
//    }
//    
//}
