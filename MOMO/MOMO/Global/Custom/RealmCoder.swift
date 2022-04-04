//
//  RealmCoder.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/04.
//

import Foundation
import RealmSwift

protocol RealmCoder {
  func decode(diary: Diary) -> DiaryEntity 
}

class MomoDiaryRealmCoder: RealmCoder {
  
  init() { }
  
  func decode(diary: Diary) -> DiaryEntity {
    
    var qnaList : [(String, String)] = []
    diary.qnaList.forEach {
      qnaList.append(($0.question, $0.answer ?? ""))
    }
    return DiaryEntity(id: "\(diary.id)", date: diary.date, emotion: DiaryEmotion(rawValue: diary.emotion) ?? .unknown, contentType: InputType(rawValue: diary.contentType) ?? .text, qnaList: qnaList)
  }
  
  
}
