//
//  CreateDiaryViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/29.
//

import Foundation

import RxSwift
import RealmSwift
import RxCocoa

class CreateDiaryViewModel: ViewModelType {
  
  // MARK: - Input
  struct Input {
    var dismissClicked: AnyObserver<Void>
    var selectEmotionButton: AnyObserver<DiaryEmotion>
    var completedClicked: AnyObserver<Void>
    var dismissWithoutSave: AnyObserver<Bool>
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var dismiss: Driver<Bool>
    var complete: Driver<Bool>
    var withInputViewModel: Driver<WithInputViewModel>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private var diaryInput: DiaryInputType
  private let repository: DiaryRepository
  private let withInputViewModel : BehaviorRelay<WithInputViewModel>
  private let baseDate: Date
  
  // MARK: - Init
  
  init(repository: DiaryRepository, diaryInput: DiaryInputType, baseDate: Date = Date()) {
    self.repository = repository
    self.diaryInput = diaryInput
    self.baseDate = baseDate
    
    if self.diaryInput.inputType == .text {
      withInputViewModel = BehaviorRelay<WithInputViewModel>(value: WithTextViewModel(hasGuide: diaryInput.hasGuide ?? true))
    } else {
      withInputViewModel = BehaviorRelay<WithInputViewModel>(value: WithTextViewModel(hasGuide: diaryInput.hasGuide ?? true))
      // TODO: 여기에 voice
    }
    
    let dismissClick = PublishSubject<Void>()
    let selectEmotion = BehaviorSubject<DiaryEmotion>(value: .happy)
    let completeClick = PublishSubject<Void>()
    let dismiss = BehaviorRelay<Bool>(value: false)
    let complete = BehaviorRelay<Bool>(value: false)
    let dismissWithoutSave = PublishSubject<Bool>()
    
    func makeWithVoiceViewModel() -> WithVoiceViewModel {
      return WithVoiceViewModel()
    }
    
    self.input = Input(dismissClicked: dismissClick.asObserver(), selectEmotionButton: selectEmotion.asObserver(), completedClicked: completeClick.asObserver(), dismissWithoutSave: dismissWithoutSave.asObserver())
    
    self.output = Output(dismiss: dismiss.asDriver(), complete: complete.asDriver(), withInputViewModel: withInputViewModel.asDriver())
    
    // MARK: - Input -> Output
      
  }
}

extension CreateDiaryViewModel {
  
  enum ViewType {
    case textFree
    case textQuestion
    case voiceFree
    case voiceQuestion
  }
  
}
