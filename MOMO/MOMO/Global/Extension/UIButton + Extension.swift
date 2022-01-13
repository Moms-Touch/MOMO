//
//  UIButton + Extension.swift
//  MOMO
//
//  Created by Cashwalk on 2022/01/08.
//

import Foundation
import UIKit

extension UIButton {
  func momoButtonStyle() {
    self.setRound(5)
    self.titleLabel?.font = UIFont.customFont(forTextStyle: .title2)
  }
}
