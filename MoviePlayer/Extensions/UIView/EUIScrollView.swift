//
//  EUIScrollView.swift
//  JJMTest
//
//  Created by Nguyên Duy on 8/1/19.
//  Copyright © 2019 Nguyên Duy. All rights reserved.
//

import Foundation
import UIKit


extension UIScrollView {
    func scrollToPage(_ page: Int, animated: Bool) {
        var frame: CGRect = self.frame
        frame.origin.x = frame.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollRectToVisible(frame, animated: animated)
    }
    
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
    func scrollTo(direction: ScrollDirection, animated: Bool = true) {
        self.setContentOffset(direction.contentOffsetWith(scrollView: self), animated: animated)
    }
    
    func scrollTo(position: CGPoint, animated: Bool = true) {
        self.setContentOffset(position, animated: animated)
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        if (bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}

enum ScrollDirection {
    case Top
    case Right
    case Bottom
    case Left
    
    func contentOffsetWith(scrollView: UIScrollView) -> CGPoint {
        var contentOffset = CGPoint.zero
        switch self {
        case .Top:
            contentOffset = CGPoint(x: 0, y: -scrollView.contentInset.top)
        case .Right:
            contentOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0)
        case .Bottom:
            if Device.isIphoneX {
                contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + 83)
            } else {
                contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + 49)
            }
        case .Left:
            contentOffset = CGPoint(x: -scrollView.contentInset.left, y: 0)
        }
        return contentOffset
    }
}
