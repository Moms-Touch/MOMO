//
//  WithInputViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/31.
//

import Foundation
import OrderedCollections

// WithTextViewModel, WithVoiceViewModel, ReadContentViewModel의 부모 뷰모델

class WithInputViewModel {
  private var hasGuide: Bool
  
  var qnaList: OrderedDictionary<String, String> = [:]
  var defaultQuestion = "자유롭게 일기를 작성해주세요."
  var guideQuestionList: [String] = [ "오늘 하루는 어떠셨나요?",
                                      "오늘 아이에게 무슨 일이 있었나요?",
                                      "남기고 싶은 말이 있나요?"
  ]
  
  init(hasGuide: Bool) {
    self.hasGuide = hasGuide
  }
}
