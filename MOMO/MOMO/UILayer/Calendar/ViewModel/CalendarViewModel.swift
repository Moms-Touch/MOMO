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
    let diaryInputOptionViewModel = BehaviorRelay<DiaryInputOptionViewModel>(value: makeDiaryInputOptionViewModel())
    let readDiaryViewModel = PublishRelay<ReadDiaryViewModel>()
    
    let toastMessage = PublishRelay<String>()
    
    self.output = Output(days: daysBehaviorRelay.asDriver(onErrorJustReturn: []),
                         numberOfWeeksInBaseDate: numberOfWeeksInBaseDate.asDriver(onErrorJustReturn: 0),
                         closeView: closeView.asDriver(onErrorJustReturn: ()),
                         calendarHeaderViewModel: calendarHeaderViewModel,
                         diaryInputOptionViewModel: diaryInputOptionViewModel.asDriver(),
                         readDiaryViewModel: readDiaryViewModel.asDriver(onErrorJustReturn: makeReadDiaryViewModel(diary: Diary())),
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
      
    didSelectOptionObservable
      .withUnretained(self)
      .filter { vm, date in
        let result = date.timeToZero() <= Date().timeToZero()
        if !result { toastMessage.accept("미래의 일기는 작성할 수 없어요") }
        return result
      }
      .flatMap { vm, date -> Observable<Diary?> in
        return vm.diaryUseCase.fetchDiary(date: date)
      }
      .filter { $0 == nil}
      .withLatestFrom(diaryInputOptionViewModel)
      .map{ _ in return makeDiaryInputOptionViewModel() }
      .bind(to: diaryInputOptionViewModel)
      .disposed(by: disposeBag)
    
    didSelectOptionObservable
      .withUnretained(self)
      .flatMap { (vm, date) -> Observable<Diary?> in
        return vm.diaryUseCase.fetchDiary(date: date)
      }
      .compactMap { $0 }
      .map { return makeReadDiaryViewModel(diary: $0)}
      .bind(to: readDiaryViewModel)
      .disposed(by: disposeBag)
      
          
    func makeCalendarHeaderViewModel() -> CalendarHeaderViewModel {
      return CalendarHeaderViewModel(baseDate: Date())
    }
    
    func makeReadDiaryViewModel(diary: Diary) -> ReadDiaryViewModel {
      return ReadDiaryViewModel()
    }
    
    func makeDiaryInputOptionViewModel() -> DiaryInputOptionViewModel {
      return DiaryInputOptionViewModel(usecase: diaryUsecase)
    }
    
    
  }
  
}
