//
//  DiaryQuestionManager.swift
//  MOMO
//
//  Created by Woochan Park on 2021/12/31.
//

import Foundation

/*
 나중에 서버에서 질문을 받아오는 것에 대비
 */

class DiaryQuestionManager {
  
  static var shared = DiaryQuestionManager()
  
  var guideQuestionList: [String] = [ "오늘 하루는 어떠셨나요?",
                                      "오늘 아이에게 무슨 일이 있었나요?",
                                      "남기고 싶은 말이 있나요?"
  ]
  
  private init() { }
}
