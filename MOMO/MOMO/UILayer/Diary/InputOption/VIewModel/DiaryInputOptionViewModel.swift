//
//  DiaryInputOptionViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/28.
//

import Foundation

import RxSwift
import RxCocoa
import AVFoundation

final class DiaryInputOptionViewModel: ViewModelType {
  
  // MARK: - Input
  struct Input {
    var inputOption: AnyObserver<InputType>
    var hasGuideOption: AnyObserver<Bool?>
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var gotoSecondStep: Driver<DiaryInputType>
    var gotocreateDiaryVC: Driver<CreateDiaryViewModel>
  }
  
  var output: Output
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private let usecase: DiaryUseCase
  private let baseDate: Date
  // MARK: - Init
  
  init(baseDate: Date, usecase: DiaryUseCase) {
    self.baseDate = baseDate
    self.usecase = usecase
    let recoder = MomoRecoder(recodingSession: AVAudioSession.sharedInstance(), audioRecoder: AVAudioRecorder())
    
    let inputOption = BehaviorSubject<InputType>(value: .text)
    let hasGuideOption = BehaviorSubject<Bool?>(value: nil)
    let gotoSecondStep = BehaviorRelay<DiaryInputType>(value: DiaryInputType(inputType: .text, hasGuide: nil))
    let gotocreateDairyVC = PublishRelay<CreateDiaryViewModel>()
  
    self.input = Input(inputOption: inputOption.asObserver(), hasGuideOption: hasGuideOption.asObserver())
    self.output = Output(gotoSecondStep: gotoSecondStep.asDriver(onErrorJustReturn: DiaryInputType(inputType: .text)), gotocreateDiaryVC: gotocreateDairyVC.asDriver(onErrorJustReturn: CreateDiaryViewModel(usecase: usecase, recoder: recoder, diaryInput: DiaryInputType(inputType: .text), baseDate: baseDate)))
    
    // MARK: - Input -> Output
    
    //step1 -> step2
    inputOption
      .map {
        return DiaryInputType(inputType: $0, hasGuide: nil)
      }
      .bind(to: gotoSecondStep)
      .disposed(by: disposeBag)
    
    //step2 -> creatDairyVM
    hasGuideOption.withLatestFrom(Observable.combineLatest(hasGuideOption.compactMap {$0}, inputOption)
      .map { hasGuide, inputType -> DiaryInputType in
        return DiaryInputType(inputType: inputType, hasGuide: hasGuide)
      }
      .map {
        CreateDiaryViewModel(usecase: usecase, recoder: recoder, diaryInput: $0, baseDate: baseDate)
      })
      .bind(to: gotocreateDairyVC)
      .disposed(by: disposeBag)
      
    
  }
  
}
