//
//  UIView+Extension.swift
//  MOMO
//
//  Created by abc on 2021/11/13.
//

import UIKit

extension UIView {
  
  // 모서리 둥글게
  func setRound(_ radius: CGFloat? = nil) {
    if let radius = radius {
      self.layer.cornerRadius = radius
    } else {
      self.layer.cornerRadius = self.bounds.height / 2
    }
    self.layer.masksToBounds = true
  }
  
  // 4방면에 border 주는 것
  func addBorder(_ arrEdge: [UIRectEdge], color: UIColor, width: CGFloat){
    for edge in arrEdge {
      let border = CALayer()
      switch edge {
      case UIRectEdge.top:
        border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
      case UIRectEdge.bottom:
        border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
      case UIRectEdge.left:
        border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
      case UIRectEdge.right:
        border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
      default:
        break
      }
      border.backgroundColor = color.cgColor
      self.layer.addSublayer(border)
    }
  }
  
  func setRound(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
  
  func momoButtonStyle() {
    self.setRound(5)
  }
  
}


