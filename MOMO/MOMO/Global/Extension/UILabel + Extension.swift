//
//  UILabel + Extension.swift
//  MOMO
//
//  Created by Cashwalk on 2022/01/08.
//

import Foundation
import UIKit

extension UILabel {
  func navTitleStyle() {
    self.font = UIFont.customFont(forTextStyle: .title1)
  }
  
  func headLineStyle() {
    self.font = UIFont.customFont(forTextStyle: .headline)
  }
  
  func subHeadLineStyle() {
    self.font = UIFont.customFont(forTextStyle: .subheadline)
  }
}
