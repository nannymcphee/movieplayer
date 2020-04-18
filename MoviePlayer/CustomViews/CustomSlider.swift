//
//  CustomSlider.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 4/18/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {

    private var thumbTouchSize = CGSize(width: 30, height: 30)

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let increasedBounds = bounds.insetBy(dx: -thumbTouchSize.width, dy: -thumbTouchSize.height)
        let containsPoint = increasedBounds.contains(point)
        return containsPoint
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let percentage = CGFloat((value - minimumValue) / (maximumValue - minimumValue))
        let thumbSizeHeight = thumbRect(forBounds: bounds, trackRect:trackRect(forBounds: bounds), value:0).size.height
        let thumbPosition = thumbSizeHeight + (percentage * (bounds.size.width - (2 * thumbSizeHeight)))
        let touchLocation = touch.location(in: self)
        return touchLocation.x <= (thumbPosition + thumbTouchSize.width) && touchLocation.x >= (thumbPosition - thumbTouchSize.width)
    }
}
