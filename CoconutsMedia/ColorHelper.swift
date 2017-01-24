//
//  ColorHelper.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 10/28/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class ColorHelper {
    
    static let lightGreen = UIColor(red: 16/255, green: 209/255, blue: 74/255, alpha: 1)
    static let blueColor = UIColor(red: 51/255, green: 122/255, blue: 183/255, alpha: 1)
    static let lightGrayColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
    static let redditLightGrayColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    static let blue = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
}

extension UIImage {
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
