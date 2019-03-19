//
//  AppExtension.swift
//  Socketawy
//
//  Created by Amr Mohamed on 7/18/18.
//  Copyright © 2018 Amr Mohamed. All rights reserved.
//

import Foundation
import AppKit

extension NSView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.8
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        layer?.add(animation, forKey: nil)
    }
}
