//
//  WithVoiceViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/30.
//

import Foundation

import RxSwift
import RxCocoa

class WithVoiceViewModel: WithInputViewModel, ViewModelType {
  
  // MARK: - Input
  
  struct Input {
    
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var datasource: Driver<[String]>
    var questionCount: Driver<Int>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private let usecase: WithVoiceUseCase
  private var defaultQuestion = "자유롭게 일기를 작성해주세요."
  private var guideQuestionList: [String] = [ "오늘 하루는 어떠셨나요?",
                                      "오늘 아이에게 무슨 일이 있었나요?",
                                      "남기고 싶은 말이 있나요?"
  ]
  
  // MARK: - init
  init(hasGuide: Bool, baseDate: Date, usecase: WithVoiceUseCase) {
    self.usecase = usecase
    
    let datasource = hasGuide == true ? BehaviorRelay<[String]>(value: guideQuestionList) : BehaviorRelay<[String]>(value: [defaultQuestion])
    let questionCount = BehaviorRelay<Int>(value: 1)
    
    datasource
      .map{ $0.count }
      .bind(to: questionCount)
      .disposed(by: disposeBag)
    
    self.input = Input()
    self.output = Output(datasource: datasource.asDriver(), questionCount: questionCount.asDriver())
    
    super.init(hasGuide: hasGuide)
  }

}
