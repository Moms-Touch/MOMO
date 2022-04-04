//
//  ReadTextCellViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/04.
//

import Foundation

import RxSwift
import RxCocoa

class ReadVoiceCellViewModel: ViewModelType {
  // MARK: - Input
  
  struct Input {
    
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var question: Driver<String>
    var answer: Driver<String>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private var defaultQuestion = "자유롭게 일기를 작성해주세요."
  private var recordPlayerPreparable: RecordPlayerPreparable
  private var recordPlayer: MomoRecordPlayer
  
  // MARK: - init
  init(question: String, answer: String, recordPlayerPreparable: RecordPlayerPreparable) {
    
    self.recordPlayerPreparable = recordPlayerPreparable
    self.recordPlayer = MomoRecordPlayer(date: recordPlayerPreparable.diaryDate)
    let questionRelay = BehaviorRelay<String>(value: question)
    let answerRelay = BehaviorRelay<String>(value: answer)
    
    self.input = Input()
    self.output = Output(question: questionRelay.asDriver(), answer: answerRelay.asDriver())
    
  }

}

