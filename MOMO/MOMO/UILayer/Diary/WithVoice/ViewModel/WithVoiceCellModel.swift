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
    var pressStart: AnyObserver<Void>
    var pressPause: AnyObserver<Void>
    var pressFinish: AnyObserver<Void>
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var currentStatus: Driver<RecordStatus>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  
  // MARK: - init
  init() {
    let pressStart = BehaviorSubject<Void>(value: ())
    let pressPause = BehaviorSubject<Void>(value: ())
    let pressFinish = BehaviorSubject<Void>(value: ())
    let currentStatus = BehaviorRelay<RecordStatus>(value: .notstarted)
        
    self.input = Input(pressStart: pressStart.asObserver(),
                       pressPause: pressPause.asObserver(),
                       pressFinish: pressFinish.asObserver())
    
    self.output = Output(currentStatus: currentStatus.asDriver())
  }

  
  
  
}
