//
//  EX_Date.swift
//  JJMTest
//
//  Created by Nguyên Duy on 8/1/19.
//  Copyright © 2019 Nguyên Duy. All rights reserved.
//

import UIKit
import Foundation

extension Date {
    func toString(_ format:NSString!) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST") // "2018-03-21 18:07:27"
        dateFormatter.dateFormat = format! as String
        
        let kr = dateFormatter.string(from: self)
        return kr
    }
    
    func dateByAddingMonths(_ months: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.month = months
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    func dateByAddingDays(_ dDays: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = dDays
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    var year: Int {
        get {
            let _val = Calendar.current.component(.year, from: self)
            return _val
        }
    }
    var month: Int {
        get {
            let _val = Calendar.current.component(.month, from: self)
            return _val
        }
    }
    var day: Int {
        get {
            let _val = Calendar.current.component(.day, from: self)
            return _val
        }
    }
    var hour: Int {
        get {
//            NSDate *date = [NSDate date];
//            NSCalendar *calendar = [NSCalendar currentCalendar];
//            NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
//            NSInteger hour = [components hour];
//            NSInteger minute = [components minute];
            
//            let dateComponents:DateComponents =  Calendar.current.dateComponents(in: TimeZone(abbreviation: "KST"), from: self)
//            dateComponents.year
            

//            Calendar.current.compare(<#T##date1: Date##Date#>, to: <#T##Date#>, toGranularity: <#T##Calendar.Component#>)
//            Calendar.current.locale = Locale(identifier: "ko_kr")
//            Calendar.current.timeZone = TimeZone(abbreviation: "KST")
//            Calendar.current.component(.timeZone)
            let _val = Calendar.current.component(.hour, from: self)
            return _val
        }
    }
    var minute: Int {
        get {
            let _val = Calendar.current.component(.minute, from: self)
            return _val
        }
    }
    
    mutating func month(_ month:Int) {
        if let date = Calendar.current.date(byAdding: .month, value: month, to: self) {
            self = date
        }
    }
    
    func addYear(_ val:Int) -> Date? {
        if let date = Calendar.current.date(byAdding: .year, value: val, to: self) {
            return date
        }
        return nil
    }
    
    func addMonth(_ val:Int) -> Date? {
        if let date = Calendar.current.date(byAdding: .month, value: val, to: self) {
            return date
        }
        return nil
    }
    
    func addDay(_ val:Int) -> Date? {
        if let date = Calendar.current.date(byAdding: .day, value: val, to: self) {
            return date
        }
        return nil
    }
    
    func addHour(_ val:Int) -> Date? {
        if let date = Calendar.current.date(byAdding: .hour, value: val, to: self) {
            return date
        }
        return nil
    }
    
    func addMin(_ val:Int) -> Date? {
        if let date = Calendar.current.date(byAdding: .minute, value: val, to: self) {
            return date
        }
        return nil
    }
    
    func addSec(_ val:Int) -> Date? {
        if let date = Calendar.current.date(byAdding: .second, value: val, to: self) {
            return date
        }
        return nil
    }
    
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    static func getCurrentDate() -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.string(from: Date())
        
    }
    
    static func getCurrentDate(dateFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: Date())
        
    }
}
