//
//  UIImage+Extension.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import UIKit

extension UIImage {
  class func colorImage(color: CGColor, size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    let graphicsContext = UIGraphicsGetCurrentContext()
    graphicsContext?.setFillColor(color)
    graphicsContext?.fill(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return colorImage
  }
}
