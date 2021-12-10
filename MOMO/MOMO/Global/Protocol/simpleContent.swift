//
//  content.swift
//  MOMO
//
//  Created by abc on 2021/11/25.
//

import Foundation

protocol simpleContent {
  var id: Int {get set}
  var title: String {get set}
  var author: String? {get set}
  var createdAt: String {get set}
  var thumbnailImageUrl: String? {get set}
}

extension simpleContent {

}
