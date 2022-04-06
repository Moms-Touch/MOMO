//
//  CalendarViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/24.
//

import Foundation
import RxSwift
import RxCocoa

class CalendarViewModel: ViewModelType {
  
  // MARK: - Input
  struct Input {
    var didSelectCell: AnyObserver<(IndexPath, Day)>
  }
  
  var input: Input
  
  // MARK: - Output
  struct Output {
    var days: Driver<[Day]>
    var numberOfWeeksInBaseDate: Driver<Int>
    var closeView: Driver<Void>
    var calendarHeaderViewModel: CalendarHeaderViewModel
    var diaryInputOptionViewModel: Driver<DiaryInputOptionViewModel>
    var readDiaryViewModel: Driver<ReadDiaryViewModel>
    var toastMessage: Driver<String>
  }
  
  var output: Output
  
  // MARK: - Private
  private let calendarUseCase: CalendarUseCase
  private let diaryUseCase: DiaryUseCase
  private var disposeBag = DisposeBag()
  
  // MARK: - init
  
  init(calendarUseCase: CalendarUseCase, diaryUsecase: DiaryUseCase) {
    let daysBehaviorRelay = BehaviorRelay<[Day]>(value: [])
    let dateSubject = BehaviorSubject<Date>(value: Date())
    self.calendarUseCase = calendarUseCase
    self.diaryUseCase = diaryUsecase
    let numberOfWeeksInBaseDate = BehaviorRelay<Int>(value: self.calendarUseCase.numberOfWeeksInBaseDate)
    let closeView = PublishRelay<Void>()
    let calendarHeaderViewModel = makeCalendarHeaderViewModel()
    
    let didSelectCellPublishSubject = PublishSubject<(IndexPath, Day)>()
    let diaryInputOptionViewModel = BehaviorRelay<DiaryInputOptionViewModel>(value: makeDiaryInputOptionViewModel(date: Date()))
    let readDiaryViewModel = PublishRelay<ReadDiaryViewModel>()
    
    let toastMessage = PublishRelay<String>()
    
    self.output = Output(days: daysBehaviorRelay.asDriver(onErrorJustReturn: []),
                         numberOfWeeksInBaseDate: numberOfWeeksInBaseDate.asDriver(onErrorJustReturn: 0),
                         closeView: closeView.asDriver(onErrorJustReturn: ()),
                         calendarHeaderViewModel: calendarHeaderViewModel,
                         diaryInputOptionViewModel: diaryInputOptionViewModel.asDriver(),
                         readDiaryViewModel: readDiaryViewModel.asDriver(onErrorJustReturn: makeReadDiaryViewModel(diary: nil)),
                         toastMessage: toastMessage.asDriver(onErrorJustReturn: "")
    )
    
    self.input = Input(didSelectCell: didSelectCellPublishSubject.asObserver())
    
    dateSubject
      .withUnretained(self)
      .flatMap {
        return $0.calendarUseCase.generateDaysInMonth(for: $1)
      }
      .bind(to: daysBehaviorRelay)
      .disposed(by: disposeBag)
    
    calendarHeaderViewModel.output.month
      .map { $0.toDate(format: "yyyy.M") ?? Date()}
      .drive(dateSubject)
      .disposed(by: disposeBag)
    
    calendarHeaderViewModel.output.closeView
      .asObservable()
      .bind(to: closeView)
      .disposed(by: disposeBag)
    
    let didSelectOptionObservable = didSelectCellPublishSubject
      .map({ index, day in
        return day.date
      })
      
    // 일기가 없음
    didSelectOptionObservable
      .withUnretained(self)
      .filter { vm, date in
        let result = date.timeToZero() <= Date().timeToZero() // bool
        if !result { toastMessage.accept("미래의 일기는 작성할 수 없어요") }
        return result
      }
      .flatMap { vm, date -> Observable<(Date, DiaryEntity?)> in //미래가 아닌 날짜만 내려옴
        return Observable.zip(Observable.just(date), vm.diaryUseCase.fetchDiary(date: date))
      }
      // 일기가 없다 -> 작성해야지
      .filter { $1 == nil }
      .withLatestFrom(diaryInputOptionViewModel, resultSelector: { tuple , _ in
        return tuple.0
      })
      .map { return makeDiaryInputOptionViewModel(date: $0)}
      .bind(to: diaryInputOptionViewModel)
      .disposed(by: disposeBag)
    
    //일기가 있음
    didSelectOptionObservable
      .withUnretained(self)
      .flatMap { (vm, date) -> Observable<DiaryEntity?> in
        return vm.diaryUseCase.fetchDiary(date: date)
      }
      .compactMap { $0 }
      .map { return makeReadDiaryViewModel(diary: $0)}
      .bind(to: readDiaryViewModel)
      .disposed(by: disposeBag)
      
          
    func makeCalendarHeaderViewModel() -> CalendarHeaderViewModel {
      return CalendarHeaderViewModel(baseDate: Date())
    }
    
    func makeReadDiaryViewModel(diary: DiaryEntity?) -> ReadDiaryViewModel {
      guard let diary = diary else {
        return ReadDiaryViewModel(diary: DiaryEntity(id: "0", date: Date(), emotion: .unknown, contentType: .text, qnaList: []), diaryUseCase: diaryUsecase)
      }

      return ReadDiaryViewModel(diary: diary, diaryUseCase: diaryUsecase)
    }
    
    func makeDiaryInputOptionViewModel(date: Date) -> DiaryInputOptionViewModel {
      return DiaryInputOptionViewModel(baseDate: date, usecase: diaryUsecase)
    }
    
    
  }
  
}
