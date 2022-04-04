//
//  ReadTextViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/04.
//

import Foundation

import RxSwift
import RxCocoa

protocol RecordPlayerPreparable {
  var diaryDate: Date { get }
}

final class ReadContentViewModel: WithInputViewModel, ViewModelType, RecordPlayerPreparable {
  
  // MARK: - Input
  
  struct Input {
    
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var qnaList: Driver<[(String, String)]>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  var contentType: InputType
  var diaryDate: Date
  
  // MARK: - init
  init(hasGuide: Bool, qnaList: [(String, String)], contentType: InputType, diaryDate: Date) {
    self.contentType = contentType
    self.diaryDate = diaryDate
    let qnaListBehaviorRelay =  BehaviorRelay<[(String,String)]>(value: qnaList)
    
    self.input = Input()
    self.output = Output(qnaList: qnaListBehaviorRelay.asDriver())
    super.init(hasGuide: hasGuide)
    
  }

}
