//
//  UISegmentedControl+Extensino.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import UIKit

extension UISegmentedControl {

  func removeBorder() {
    let colorImage = UIImage.colorImage(color: UIColor.white.cgColor, size: self.bounds.size)
    self.setBackgroundImage(colorImage, for: .normal, barMetrics: .default)
    self.setBackgroundImage(colorImage, for: .selected, barMetrics: .default)
    self.setBackgroundImage(colorImage, for: .highlighted, barMetrics: .default)

    let devider = UIImage.colorImage(color: UIColor.white.cgColor, size: CGSize(width: 1.0, height: self.bounds.size.height))
    self.setDividerImage(devider, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
    self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)], for: .selected)
  }
  
}
