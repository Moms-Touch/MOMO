//
//  WithTextCellViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/30.
//

import Foundation

import RxSwift
import RxCocoa
import RealmSwift

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
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private var defaultQuestion = "자유롭게 일기를 작성해주세요."
  private var qnaRelay: DiaryContentGetable
  
  // MARK: - init
  init(question: String, index: String, qnaRelay: DiaryContentGetable) {
    let questionRelay = BehaviorRelay<String>(value: question)
    let indexStr = question == defaultQuestion ? "" : index
    let indexRelay = BehaviorRelay<String>(value: indexStr)
    let textBehaviorSubject = BehaviorSubject<String>(value: "")
    
    self.qnaRelay = qnaRelay
    self.input = Input(content: textBehaviorSubject.asObserver())
    self.output = Output(question: questionRelay.asDriver(), index: indexRelay.asDriver())
    
    //input -> Output
    textBehaviorSubject
      .map { return [question: $0] }
      .bind(to: qnaRelay.qnaListBehaviorRelay)
      .disposed(by: disposeBag)
      
  }

}
