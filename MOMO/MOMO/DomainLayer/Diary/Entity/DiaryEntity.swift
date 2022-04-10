//
//  DiaryEntity.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/04.
//

import Foundation

struct DiaryEntity: Equatable {
  static func == (lhs: DiaryEntity, rhs: DiaryEntity) -> Bool {
    return lhs.id == rhs.id
  }
  
  var id: String
  var date: Date
  var emotion: DiaryEmotion
  var contentType: InputType
  var qnaList: [(String, String)]
}
