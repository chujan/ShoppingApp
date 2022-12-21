//
//  Extension.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 06/12/2022.
//

import Foundation

import UIKit

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    var height: CGFloat {
        return frame.size.height
    }
    var left: CGFloat {
        return frame.origin.x
    }
    var right: CGFloat {
        return left + width
    }
    var top: CGFloat {
        return frame.origin.y
    }
    var bottom: CGFloat {
        return top + height
    }
}
extension Notification.Name {
  
    static let didLogInNotification = Notification.Name("didLogInNotification")
}
