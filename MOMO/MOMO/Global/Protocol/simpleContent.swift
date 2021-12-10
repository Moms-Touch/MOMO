//
//  content.swift
//  MOMO
//
//  Created by abc on 2021/11/25.
//

import Foundation

// simpleContent는 모델중에 tableviewcell이나 collectionviewcell에 쓰이는 모델에 채택하여 사용한다.

protocol simpleContent {
  var id: Int {get set}
  var title: String {get set}
  var author: String? {get set}
  var createdAt: String {get set}
  var thumbnailImageUrl: String? {get set}
}

extension simpleContent {

}
