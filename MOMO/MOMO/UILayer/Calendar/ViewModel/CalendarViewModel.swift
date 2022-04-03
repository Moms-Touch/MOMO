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
  }
  
  var output: Output
  
  // MARK: - Private
  private let calendarUseCase: CalendarUseCase
  private var disposeBag = DisposeBag()
  
  // MARK: - init
  
  init(calendarUseCase: CalendarUseCase) {
    let daysBehaviorRelay = BehaviorRelay<[Day]>(value: [])
    let dateSubject = BehaviorSubject<Date>(value: Date())
    self.calendarUseCase = calendarUseCase
    let numberOfWeeksInBaseDate = BehaviorRelay<Int>(value: self.calendarUseCase.numberOfWeeksInBaseDate)
    let closeView = PublishRelay<Void>()
    let calendarHeaderViewModel = makeCalendarHeaderViewModel()
    let didSelectCellPublishSubject = PublishSubject<(IndexPath, Day)>()
    
    self.output = Output(days: daysBehaviorRelay.asDriver(onErrorJustReturn: []),
                         numberOfWeeksInBaseDate: numberOfWeeksInBaseDate.asDriver(onErrorJustReturn: 0),
                         closeView: closeView.asDriver(onErrorJustReturn: ()),
                         calendarHeaderViewModel: calendarHeaderViewModel)
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
  
    func makeCalendarHeaderViewModel() -> CalendarHeaderViewModel {
      return CalendarHeaderViewModel(baseDate: Date())
    }
    
    func makeReadDiaryViewModel() {
      
    }
    
    func makeDiaryInputOptionViewModel() {
      
    }
    
    
  }
  
}
