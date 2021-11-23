//
//  NibLoadable.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import UIKit

protocol NibLoadableView: AnyObject { }

extension NibLoadableView where Self: UIView {
  static var NibName: String {
    return String(describing: self)
  }
}
