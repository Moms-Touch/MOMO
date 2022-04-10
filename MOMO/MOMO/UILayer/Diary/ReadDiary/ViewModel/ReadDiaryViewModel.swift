//
//  ReadDiaryViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/03.
//

import Foundation

import RxSwift
import RxCocoa

class ReadDiaryViewModel: ViewModelType {

  // MARK: - Input
  
  struct Input {
    var deleteButtonClicked: AnyObserver<Void>
    var dismissClicked: AnyObserver<Void>
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var dismiss: Driver<Void>
    var withInputViewModel: Driver<WithInputViewModel>
    var date: Driver<String>
    var emotion: Driver<(DiaryEmotion, Int)>
    var deleteCompleted: Driver<Bool>
    var toastMessage: Driver<String>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private let diaryUseCase: DiaryUseCase
  
  // MARK: - init
  init(diary: DiaryEntity, diaryUseCase: DiaryUseCase) {
    self.diaryUseCase = diaryUseCase
    
    let dismissClicked = PublishSubject<Void>()
    let deleteButtonClicked = PublishSubject<Void>()
    
    let diary = BehaviorRelay<DiaryEntity>(value: diary)
    let deleteCompleted = PublishRelay<Bool>()
    let toastmessage = PublishRelay<String>()
    let diaryEmotion = BehaviorRelay<(DiaryEmotion, Int)>(value: (.unknown, DiaryEmotion.allCases.count))
    let baseDate = BehaviorRelay<String>(value: Date().toString(format: "yyyy.MM.dd"))
    
    let withInputViewModel = BehaviorRelay<WithInputViewModel>(value: WithInputViewModel(hasGuide: false))
    
    self.input = Input(deleteButtonClicked: deleteButtonClicked.asObserver(), dismissClicked: dismissClicked.asObserver())
    
    self.output = Output(dismiss: dismissClicked.asDriver(onErrorJustReturn: ()),
                         withInputViewModel: withInputViewModel.asDriver(),
                         date: baseDate.asDriver(),
                         emotion: diaryEmotion.asDriver(),
                         deleteCompleted: deleteCompleted.asDriver(onErrorJustReturn: false),
                         toastMessage: toastmessage.asDriver(onErrorJustReturn: ""))
    
    
    diary
      .map { ($0.emotion, DiaryEmotion.allCases.firstIndex(of: $0.emotion) ?? DiaryEmotion.allCases.count) }
      .bind(to: diaryEmotion)
      .disposed(by: disposeBag)
    
    diary
      .map { $0.date.toString(format: "yyyy.MM.dd") }
      .bind(to: baseDate)
      .disposed(by: disposeBag)
    
    // DiaryEntity를 활용해서 하위 ViewModel을 제작한다.
    diary
      .map { diary in
        return ReadContentViewModel(hasGuide: diary.qnaList.count == 3,
                                    qnaList: diary.qnaList,
                                    contentType: diary.contentType,
                                    diaryDate: diary.date) as WithInputViewModel

      }
      .bind(to: withInputViewModel)
      .disposed(by: disposeBag)
     
    
    deleteButtonClicked.withLatestFrom(diary)
      .withUnretained(self)
      .flatMap { vm, diary -> Observable<Bool> in
        return diaryUseCase.deleteDiary(diary: diary)
          .andThen(Observable.just(true))
      }
      .bind(to: deleteCompleted)
      .disposed(by: disposeBag)
  
  }
}
