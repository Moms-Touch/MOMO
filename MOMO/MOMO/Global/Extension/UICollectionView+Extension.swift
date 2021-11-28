//
//  UICollectionView+Extension.swift
//  MOMO
//
//  Created by abc on 2021/11/25.
//

import Foundation
import UIKit

extension UICollectionView {
  func register<T: UICollectionViewCell>(_ cellClass: T.Type){
    let identifier = T.identifier
    self.register(T.self, forCellWithReuseIdentifier: identifier)
  }
  
  func register<T: UICollectionViewCell>(_: T.Type) where T: NibLoadableView {
    let nib = UINib(nibName: T.NibName, bundle: nil)
    register(nib, forCellWithReuseIdentifier: T.identifier)
  }
}
