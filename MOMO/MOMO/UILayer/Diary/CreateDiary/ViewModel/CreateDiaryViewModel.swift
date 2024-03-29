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
  // content는 question과 answer의 내용을 가지고 있다.
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
    var date: Driver<String>
    var gotoOption: Driver<Void>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private let baseDate: Date
  private let usecase: DiaryUseCase
  private let recoder: Recoder
  var content: BehaviorRelay<[(String, String)]>
  
  // MARK: - Init
  
  init(usecase: DiaryUseCase, recoder: Recoder, diaryInput: DiaryInputType, baseDate: Date = Date()) {
    
    // MARK: - dependencies
    self.baseDate = baseDate
    self.content = BehaviorRelay<[(String, String)]>(value: [])
    self.usecase = usecase
    self.recoder = recoder
    
    // MARK: - Streams
    
    //output Stream
    let withInputViewModel = BehaviorRelay<WithInputViewModel>(value: WithInputViewModel(hasGuide: false))
    let dateString = BehaviorRelay<String>(value: baseDate.toString())
    let dismiss = BehaviorRelay<Void>(value: ())
    let selectEmotion = BehaviorSubject<DiaryEmotion>(value: .unknown)
    let gotoOption = PublishRelay<Void>()
    
    //input stream
    let completeClick = PublishSubject<Void>()
    let dismissClick = PublishSubject<Void>()
    let dismissWithoutSave = PublishSubject<Bool>()
    let complete = BehaviorRelay<Bool>(value: false)
    
    self.input = Input(dismissClicked: dismissClick.asObserver(),
                       selectEmotionButton: selectEmotion.asObserver(),
                       completedClicked: completeClick.asObserver(),
                       dismissWithoutSave: dismissWithoutSave.asObserver())
    
    self.output = Output(dismiss: dismiss.asDriver(),
                         complete: complete.asDriver(),
                         withInputViewModel: withInputViewModel.asDriver(),
                         date: dateString.asDriver(),
                         gotoOption: gotoOption.asDriver(onErrorJustReturn: ()))
    
    if diaryInput.inputType == .text {
      //Diary를 만드는데 필요한 메타데이터를 넘긴다.
      withInputViewModel.accept(WithTextViewModel(hasGuide: diaryInput.hasGuide ?? true, baseDate: self.baseDate, content: self))
    } else {
      withInputViewModel.accept(
        WithVoiceViewModel(hasGuide: diaryInput.hasGuide ?? true, baseDate: self.baseDate, recoder: self.recoder, content: self))
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
      .flatMap { [weak self] qnas, emotion -> Observable<DiaryEntity> in
        guard let self = self else {
          return Observable.error(AppError.noSelf)
        }
        return self.usecase.saveDiary(date: self.baseDate, emotion: emotion, contentType: diaryInput.inputType, qnas: qnas)
      }
      .map { _ in return true }
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
