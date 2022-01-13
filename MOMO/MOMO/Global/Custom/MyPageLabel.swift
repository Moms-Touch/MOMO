//
//  MyPageLable.swift
//  MOMO
//
//  Created by Cashwalk on 2022/01/08.
//

import Foundation
import UIKit

class MyPageLabel: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    applyMyPageLabelDesign()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    applyMyPageLabelDesign()
  }
  
  private func applyMyPageLabelDesign() {
    self.font = UIFont.customFont(forTextStyle: .footnote)
  }
}
