//
//  ViewModelBindable.swift
//  MOMO
//
//  Created by abc on 2022/03/13.
//

import UIKit

protocol ViewModelBindableType: AnyObject {
  associatedtype ViewModelType
  
  var viewModel: ViewModelType {get set}
  func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
  func bind(viewModel: Self.ViewModelType) {
    self.viewModel = viewModel
    loadViewIfNeeded()
    
    bindViewModel()
  }
}
