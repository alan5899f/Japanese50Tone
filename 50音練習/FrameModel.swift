//
//  FrameModel.swift
//  FrameModel
//
//  Created by 陳韋綸 on 2022/1/25.
//

import Foundation
import UIKit

extension UIView {
    
    public var top: CGFloat {
        return frame.origin.y
    }
    public var left: CGFloat {
        return frame.origin.x
    }
    public var right: CGFloat {
        return frame.origin.x + frame.self.width
    }
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var width: CGFloat {
        return frame.size.width
    }
}
