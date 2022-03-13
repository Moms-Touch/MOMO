//
//  MyInfoViewModel.swift
//  MOMO
//
//  Created by abc on 2022/03/12.
//

import Foundation
import RxSwift
import RxCocoa

final class MyInfoCellViewModel {
  
  //MARK: - private
  
  private var index: Int
  private var content: [String]
  
  //MARK: - init
  
  init(index: Int, content: [String]) {
    self.index = index
    self.content = content
  }
  
}
