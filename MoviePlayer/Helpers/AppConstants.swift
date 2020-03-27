//
//  AppConstants.swift
//  joojoome_ios
//
//  Created by MacBookj on 8/2/19.
//  Copyright © 2019 JOOJOOMEE. All rights reserved.
//

import Foundation
import UIKit

class AppConstants {
   
    
    //    #if DEV || INTEGRATION
    //    public static let baseNodeNextgenURLString = "http://192.168.1.95:5030/"
    //    public static let baseAvatarURL =  baseNodeNextgenURLString + "/avatar/"
    //    #elseif STAGING
    //    public static let baseNodeNextgenURLString = "http://192.168.1.95:5030/"
    //    public static let baseAvatarURL =  baseNodeNextgenURLString + "/avatar/"
    //    #elseif PRELIVE
    //    public static let baseNodeNextgenURLString = "http://192.168.1.95:5030/"
    //    public static let baseAvatarURL =  baseNodeNextgenURLString + "/avatar/"
    //    #elseif PRODUCTION || LIVE
    //    public static let baseNodeNextgenURLString = "http://192.168.1.95:5030/"
    //    public static let baseAvatarURL =  baseNodeNextgenURLString + "/avatar/"
    //    #else
    // #endif
   
    public static let URLConnect = "https://joojoomee.com:12540"
    public static let baseAvatarURL =  URLConnect + "/avatar/"
    public static let pathUser = "/users/"
    public static let pathPublicLed = "/public-leds/"
    public static let pathPublicAudio = "/public-audio-apps/"
    public static let pathPublicMiniApp = "/public-custom-apps/"
    public static let pathPrivateLed = "/private-leds/"
    public static let pathDeviceInfo = "/jjmd/get-device-info/"
    public static let pathListNewFirmware = "/jjmd/get-firmware-info/"
    public static let pathRegisterDevice = "/jjmd/register-device/"
    public static let pathGetListRegisterDevice = "/jjmd/get-registered-device-info/"
    public static let pathNotification = "/notification/"
    public static let pathLockDevice = "/jjmd/lock-device/"
    public static let pathUnlockDevice = "/jjmd/unlock-device/"
    public static let pathGetAppData = "/jjmd/get-app/"

    public static let pathCollectedLed = "/collected-leds/"
    public static let pathCollectedAudio = "/collected-audio-apps/"
    public static let pathCollectedMiniApp = "/collected-custom-apps/"
    public static let defaultAvatarName = "icons8_alligator_96px"
    public static let apiTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    public static let appDisplayTimeFormat = "dd.MM.yyyy"
    
    public static let notificationDeleteAppSuccess = "DeleteAppSuccess"
    
}
