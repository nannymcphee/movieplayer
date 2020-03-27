//
//  LocalData.swift
//  joojoome_ios
//
//  Created by Nguyên Duy on 8/27/19.
//  Copyright © 2019 JOOJOOMEE. All rights reserved.
//

import UIKit

class LocalData {
    private static var sharedManager: LocalData = {
        let localData = LocalData()
        return localData
    }()
    
    //MARK: - ACCESSOR
    class func shared() -> LocalData {
        return sharedManager
    }
}
