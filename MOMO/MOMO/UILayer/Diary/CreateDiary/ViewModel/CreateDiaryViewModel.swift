//
//  CreateDiaryViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/29.
//

import Foundation

import RxSwift
import RxCocoa

protocol DiaryContentMakeable {
  var content: BehaviorRelay<[(String, String)]> {get set}
}

class CreateDiaryViewModel: ViewModelType, DiaryContentMakeable {
  
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
    var dismiss: Driver<Void>
    var complete: Driver<Bool>
    var withInputViewModel: Driver<WithInputViewModel>
    var gotoOption: Driver<Void>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private let baseDate: Date
  private let usecase: CreateDiaryUseCase
  private let voiceUsecase: WithVoiceUseCase
  var content: BehaviorRelay<[(String, String)]>
  
  // MARK: - Init
  
  init(usecase: CreateDiaryUseCase, voiceUsecase: WithVoiceUseCase, diaryInput: DiaryInputType, baseDate: Date = Date()) {
    self.baseDate = baseDate
    self.content = BehaviorRelay<[(String, String)]>(value: [])
    self.usecase = usecase
    self.voiceUsecase = voiceUsecase
    let withInputViewModel = BehaviorRelay<WithInputViewModel>(value: WithInputViewModel(hasGuide: false))
    
    let dismissClick = PublishSubject<Void>()
    let selectEmotion = BehaviorSubject<DiaryEmotion>(value: .unknown)
    let completeClick = PublishSubject<Void>()
    let dismiss = BehaviorRelay<Void>(value: ())
    let gotoOption = PublishRelay<Void>()
    let complete = BehaviorRelay<Bool>(value: false)
    let dismissWithoutSave = PublishSubject<Bool>()
    
    self.input = Input(dismissClicked: dismissClick.asObserver(),
                       selectEmotionButton: selectEmotion.asObserver(),
                       completedClicked: completeClick.asObserver(),
                       dismissWithoutSave: dismissWithoutSave.asObserver())
    
    self.output = Output(dismiss: dismiss.asDriver(),
                         complete: complete.asDriver(),
                         withInputViewModel: withInputViewModel.asDriver(),
                         gotoOption: gotoOption.asDriver(onErrorJustReturn: ()))
    
    if diaryInput.inputType == .text {
      //Diary를 만드는데 필요한 메타데이터를 넘긴다.
      withInputViewModel.accept(WithTextViewModel(hasGuide: diaryInput.hasGuide ?? true, baseDate: self.baseDate, content: self))
    } else {
      withInputViewModel.accept(
        WithVoiceViewModel(hasGuide: diaryInput.hasGuide ?? true, baseDate: self.baseDate, usecase: self.voiceUsecase, content: self))
    }
    
      // TODO: 여기에 voice
    // MARK: - Input -> Output
    
    let saveObservable = Observable.combineLatest(self.content, selectEmotion)
    
    dismissClick
      .bind(to: dismiss)
      .disposed(by: disposeBag)
    
    dismissWithoutSave
      .map { _ in return ()}
      .bind(to: gotoOption)
      .disposed(by: disposeBag)
      
    completeClick
      .withLatestFrom(saveObservable)
      .flatMap { [weak self] qnas, emotion -> Observable<Diary> in
        guard let self = self else {
          return Observable.error(AppError.noSelf)
        }
        return self.usecase.saveDiary(date: self.baseDate, emotion: emotion, contentType: diaryInput.inputType, qnas: qnas)
      }
      .map { dairy in
        print(dairy)
        return true
      }
      .bind(to: complete)
      .disposed(by: disposeBag)
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
