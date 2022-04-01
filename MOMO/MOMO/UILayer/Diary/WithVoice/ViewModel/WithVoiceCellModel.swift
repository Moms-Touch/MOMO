//
//  WithVoiceCellModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/31.
//

import Foundation

import RxSwift
import RxCocoa

final class WithVoiceCellModel {
  
  // MARK: - Input
  
  struct Input {
    var recordButtonClicked: AnyObserver<Void>
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var currentStatus: Driver<RecordStatus>
    var question: Driver<String>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private var voiceRecordHelper: VoiceRecordable
  // MARK: - init
  init(question: String, voiceRecordHelper: VoiceRecordable) {
    self.voiceRecordHelper = voiceRecordHelper
    let recordButtonClicked = PublishSubject<Void>()
    let currentStatus = BehaviorRelay<RecordStatus>(value: .notstarted)
    let questionRelay = BehaviorRelay<String>(value: question)
    self.input = Input(recordButtonClicked: recordButtonClicked.asObserver())
    
    self.output = Output(currentStatus: currentStatus.asDriver(), question: questionRelay.asDriver())
    
    // MARK: - Input -> Output
    
    recordButtonClicked.withLatestFrom(currentStatus)
      .distinctUntilChanged()
      .withUnretained(self)
      .flatMap { (cm, status: RecordStatus) -> Observable<RecordStatus> in
        switch status {
        case .notstarted:
          return cm.voiceRecordHelper.usecase.startRecording(date: voiceRecordHelper.baseDate)
        case .recording:
          return cm.voiceRecordHelper.usecase.finishRecording(success: true)
        case .finished:
          return cm.voiceRecordHelper.usecase.finishRecording(success: true)
        }
      }
      .bind(to: currentStatus)
      .disposed(by: disposeBag)
    
    // finish했을때, qnaListBehaviorRelay에 url을 담아서 보낸다.
    currentStatus
      .filter { $0 == .finished }
      .withUnretained(self)
      .flatMap { cm, status -> (Observable<String>) in
        return  cm.voiceRecordHelper.usecase.savedURL
      }
      .map { return [question: $0]}
      .bind(to: voiceRecordHelper.qnaListBehaviorRelay)
      .disposed(by: disposeBag)
    
  }
  
}
