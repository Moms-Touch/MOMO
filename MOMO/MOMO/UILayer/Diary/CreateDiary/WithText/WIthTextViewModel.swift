//
//  WIthTextViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/30.
//

import Foundation

import OrderedCollections
import RxSwift
import RxCocoa

class WithInputViewModel {
  private var hasGuide: Bool
  
  init(hasGuide: Bool) {
    self.hasGuide = hasGuide
  }
}

class WithTextViewModel: WithInputViewModel, ViewModelType {
  
  // MARK: - Input
  struct Input {
    
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var datasource: Driver<[String]>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  
  private var qnaList: OrderedDictionary<String, String> = [:]
  private var defaultQuestion = "자유롭게 일기를 작성해주세요."
  private var guideQuestionList: [String] = [ "오늘 하루는 어떠셨나요?",
                                      "오늘 아이에게 무슨 일이 있었나요?",
                                      "남기고 싶은 말이 있나요?"
  ]
  private var disposeBag = DisposeBag()

  override init(hasGuide: Bool) {
    
    let datasource = hasGuide == true ? BehaviorRelay<[String]>(value: guideQuestionList) : BehaviorRelay<[String]>(value: [defaultQuestion])
    
    self.input = Input()
    self.output = Output(datasource: datasource.asDriver())
    super.init(hasGuide: hasGuide)
  }
}
