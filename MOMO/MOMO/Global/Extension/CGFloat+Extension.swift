//
//  NSLayoutConstraint+Extension.swift
//  MOMO
//
//  Created by abc on 2021/12/02.
//

import Foundation
import UIKit

extension CGFloat {
  func fit<T: UIViewController>(_ viewcontroller: T) -> CGFloat{
    return self * viewcontroller.view.frame.height / 812
  }
  
  func seFit<T: UIViewController>(_ viewcontroller: T) -> CGFloat{
    return self * viewcontroller.view.frame.height / 667
  }
  
  var ratio: CGFloat {
    let ratio = UIScreen.main.bounds.width / 414
    return self * ratio
  }
}
