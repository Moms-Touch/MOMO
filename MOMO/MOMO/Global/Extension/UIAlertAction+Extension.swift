//
//  UIAlertAction+Extension.swift
//  MOMO
//
//  Created by Woochan Park on 2021/12/31.
//

import Foundation
import UIKit

extension UIAlertAction {
  
  /// Cancel Action with No Handler
  static var okAction: UIAlertAction {
    
    return UIAlertAction(title: "네", style: .default, handler: nil)
  }
  
  /// Cancel Action with No Handler
  static var cancelAction: UIAlertAction {
    
    return UIAlertAction(title: "아니오", style: .cancel, handler: nil)
  }
  
}
