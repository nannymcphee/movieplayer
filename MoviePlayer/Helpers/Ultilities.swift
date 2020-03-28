//
//  Ultilities.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 3/28/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//

import UIKit


struct Ultilities {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        Helper.appDelegate.orientationLock = orientation
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}
