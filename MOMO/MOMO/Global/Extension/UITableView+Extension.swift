//
//  UITableView+Extension.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import Foundation
import UIKit

extension UITableView {
  func register<T: UITableViewCell>(_ cellClass: T.Type){
    let identifier = T.identifier
    self.register(T.self, forCellReuseIdentifier: identifier)
  }
  
  func register<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
    let nib = UINib(nibName: T.NibName, bundle: nil)
    register(nib, forCellReuseIdentifier: T.identifier)
  }
  
}
