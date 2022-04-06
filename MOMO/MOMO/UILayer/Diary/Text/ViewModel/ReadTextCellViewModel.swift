//
//  ReadTextCellViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/04.
//

import Foundation

import RxSwift
import RxCocoa

class ReadTextCellViewModel: ViewModelType {
  // MARK: - Input
  
  struct Input {
    
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var question: Driver<String>
    var answer: Driver<String>
    var index: Driver<String>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private var defaultQuestion = "자유롭게 일기를 작성해주세요."
  
  // MARK: - init
  init(question: String, answer: String, index: String) {
    let questionRelay = BehaviorRelay<String>(value: question)
    let indexStr = question == defaultQuestion ? "" : index
    let indexRelay = BehaviorRelay<String>(value: indexStr)
    let answerRelay = BehaviorRelay<String>(value: answer)
    
    self.input = Input()
    self.output = Output(question: questionRelay.asDriver(), answer: answerRelay.asDriver(), index: indexRelay.asDriver())
  }

}
