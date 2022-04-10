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

// MARK: - ReadContentViewModel은 ReadText, ReadVoice가 합쳐진 ViewModel, Text는 내용, Voice는 URL의 string version이 들어있기 때문에 둘을 합칠 수 있었다.
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
