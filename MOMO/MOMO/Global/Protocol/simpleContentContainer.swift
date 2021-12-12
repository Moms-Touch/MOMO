//
//  simpleContentContainer.swift
//  MOMO
//
//  Created by abc on 2021/11/25.
//

import Foundation

protocol simpleContentContainer: ReusableView{
  var data: simpleContent? {get set}
}

extension simpleContentContainer {
  func getSimpleData<T: simpleContent>(data: T) {
    self.data = data
  }
}

