//
//  Video.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 3/27/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//

import UIKit

class Video {
    var id = UUID().uuidString
    var title: String?
    var source: String?
    var subtitle: String?
    var description: String?
    private var thumb: String?
    var thumbImage: UIImage? {
        if let thumbName = thumb {
            return UIImage(named: thumbName)
        } else {
            return nil
        }
    }
    
    init() {}
    
    init(json: [String: Any]) {
        if let title = json["title"] as? String {
            self.title = title
        }
        
        if let source = json["source"] as? String {
            self.source = source
        }
        
        if let subtitle = json["subtitle"] as? String {
            self.subtitle = subtitle
        }
        
        if let thumb = json["thumb"] as? String {
            self.thumb = thumb
        }
        
        if let description = json["description"] as? String {
            self.description = description
        }
    }
}
