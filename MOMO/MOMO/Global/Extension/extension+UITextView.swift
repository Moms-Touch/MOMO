//
//  extension+UITextView.swift
//  MOMO
//
//  Created by abc on 2022/01/04.
//

import Foundation
import UIKit

extension UITextView {
  
  func addDoneButton(title: String, target:Any, selector: Selector) {
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44.0))
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
            toolbar.setItems([flexible, barButton], animated: false)
            self.inputAccessoryView = toolbar
  }
  

}
