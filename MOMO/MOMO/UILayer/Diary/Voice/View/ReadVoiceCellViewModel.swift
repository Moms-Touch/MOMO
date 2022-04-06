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
    var playerButtonClicked: AnyObserver<Void>
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var question: Driver<String>
    var currentStatus: Driver<PlayerStatus>
    var playerTimer: Driver<(String, String)>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private var defaultQuestion = "자유롭게 일기를 작성해주세요."
  private var recordPlayerPreparable: RecordPlayerPreparable
  private var recordPlayer: RecordPlayer
  
  // MARK: - init
  init(question: String, recordPlayerPreparable: RecordPlayerPreparable, recordPlayer: RecordPlayer) {
    
    self.recordPlayerPreparable = recordPlayerPreparable
    
    self.recordPlayer = recordPlayer
    
    let questionRelay = BehaviorRelay<String>(value: question)
    let playerButtonClicked = PublishSubject<Void>()
    let currentStatus = BehaviorRelay<PlayerStatus>(value: .notStarted)
    let playerTimer = BehaviorRelay<(String, String)>(value: ("", ""))
    
    self.input = Input(playerButtonClicked: playerButtonClicked.asObserver())
    self.output = Output(question: questionRelay.asDriver(),
                         currentStatus: currentStatus.asDriver(),
                         playerTimer: playerTimer.asDriver()
    )
    
    playerButtonClicked.withLatestFrom(currentStatus)
      .withUnretained(self)
      .flatMap { vm, status -> Observable<PlayerStatus> in
        switch status {
        case .notStarted:
          vm.recordPlayer.play()
        case .nowPlaying:
          vm.recordPlayer.pause()
        case .pause:
          vm.recordPlayer.play()
        case .stop:
          vm.recordPlayer.stop()
        }
        return vm.recordPlayer.recordPlayerStatus.asObservable()
      }
      .bind(to: currentStatus)
      .disposed(by: disposeBag)
    
    
    let durationStatus = Observable<Int>
      .timer(.milliseconds(0),period: .milliseconds(300), scheduler: MainScheduler.instance)
      .withUnretained(self)
      .flatMap({ vm, _ -> Observable<(String, String)> in
        return vm.recordPlayer.durationAndCurrentTime()
      })
      .share()

    durationStatus
      .distinctUntilChanged{ (lhs, rhs) in
        return lhs.0 == rhs.0 && lhs.1 == rhs.1
      }
      .bind(to: playerTimer)
      .disposed(by: disposeBag)
    
    playerTimer
      .bind(onNext: {
          print($0)
      })
      .disposed(by: disposeBag)

  }

}

