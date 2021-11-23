//
//  UITextField.swift
//  MOMO
//
//  Created by 오승기 on 2021/11/23.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        leftView = paddingView
        leftViewMode = ViewMode.always
    }
}
