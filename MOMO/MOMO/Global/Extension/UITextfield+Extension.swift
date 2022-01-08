//
//  UITextfield+Extension.swift
//  MOMO
//
//  Created by abc on 2021/11/14.
//

import UIKit

extension UITextField {
  func addLeftPadding(width: CGFloat) {
    let padding = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.bounds.height))
    self.leftView = padding
    self.leftViewMode = ViewMode.always
  }
  
  func setUpFontStyle() {
    self.font = UIFont.customFont(forTextStyle: .footnote)
  }
}

