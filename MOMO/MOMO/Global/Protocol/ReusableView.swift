//
//  ReusableView.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import Foundation
import UIKit

// tableview, collectionview에 identifier 쓸때 파일이름과 동일하게
// 사용할때는 00Cell.identifier

protocol ReusableView: AnyObject {
  
}

extension ReusableView where Self: UIView {
  static var identifier: String {
    return String(describing: self)
  }
}

extension UICollectionViewCell: ReusableView {}
extension UITableViewCell: ReusableView {}
