//
//  NibInstantiatable.swift
//
//  Created by Woochan Park on 2021/08/23.
//

import UIKit

protocol NibInstantiatable {
  
  static var nib: UINib { get }
  
  static func instantiateFromNib() -> Self
}

extension NibInstantiatable {
  
  static var nib: UINib {
    UINib(nibName: String(describing: self), bundle: nil)
  }
  
  static func instantiateFromNib() -> Self {
    
    let nib = UINib(nibName: String(describing: self), bundle: nil)
    
    return nib.instantiate(withOwner: self, options: nil).first as! Self
  }
}

