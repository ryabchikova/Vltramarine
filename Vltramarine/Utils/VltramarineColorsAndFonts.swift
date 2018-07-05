//
//  VltramarineColorsAndFonts.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 04/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import UIKit

fileprivate let rgb: (Int, Int, Int, CGFloat) -> UIColor = {
    return UIColor(red: CGFloat($0)/255, green: CGFloat($1)/255.0, blue: CGFloat($2)/255.0, alpha: $3)
}

fileprivate let rgbOpaque: (Int, Int, Int) -> UIColor = {
    return UIColor(red: CGFloat($0)/255, green: CGFloat($1)/255.0, blue: CGFloat($2)/255.0, alpha: 1.0)
}

let vltrmnDarkGrayColor = rgb(61, 65, 80, 0.7)
let vltrmnLightGrayColor = rgb(224, 224, 224, 0.9)
let vltrmnWhiteColor = rgbOpaque(255, 255, 255)

// Fonts
let vltrmnMenuItemFont: UIFont = UIFont.init(name: "CourierNewPS-BoldItalicMT", size: 20.0)!
let vltrmnDetailFont: UIFont = UIFont.init(name: "CourierNewPS-BoldItalicMT", size: 14.0)!






