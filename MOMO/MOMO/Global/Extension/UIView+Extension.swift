//
//  UIView+Extension.swift
//  MOMO
//
//  Created by abc on 2021/11/13.
//

import UIKit

extension UIView {
  func setRound(_ radius: CGFloat? = nil) {
    if let radius = radius {
      self.layer.cornerRadius = radius
    } else {
      self.layer.cornerRadius = self.bounds.height / 2
    }
    self.layer.masksToBounds = true
  }
}


