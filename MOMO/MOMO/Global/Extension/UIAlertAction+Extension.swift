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
    
    return UIAlertAction(title: "알겠어요", style: .default, handler: nil)
  }
  
  /// Cancel Action with No Handler
  static var cancelAction: UIAlertAction {
    
    return UIAlertAction(title: "취소할게요", style: .default, handler: nil)
  }
  
}
