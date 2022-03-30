//
//  WithTextCellViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/30.
//

import Foundation

import RxSwift
import RxCocoa

class WithTextCellViewModel: ViewModelType {
 
  // MARK: - Input
  
  struct Input {
    var content: AnyObserver<String>
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var question: Driver<String>
    var index: Driver<String>
    var content: Driver<String>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private var defaultQuestion = "자유롭게 일기를 작성해주세요."

  
  // MARK: - init
  init(question: String, index: String) {
    let questionRelay = BehaviorRelay<String>(value: question)
    let indexStr = question == defaultQuestion ? "" : index
    let indexRelay = BehaviorRelay<String>(value: indexStr)
    let textBehaviorSubject = BehaviorSubject<String>(value: "")
    
    self.input = Input(content: textBehaviorSubject.asObserver())
    self.output = Output(question: questionRelay.asDriver(), index: indexRelay.asDriver(), content: textBehaviorSubject.asDriver(onErrorJustReturn: "오류"))
  }
  
}
