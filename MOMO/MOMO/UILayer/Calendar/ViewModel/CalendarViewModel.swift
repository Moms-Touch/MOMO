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
    
  }
  
  var input: Input
  
  // MARK: - Output
  struct Output {
    var days: Driver<[Day]>
    var numberOfWeeksInBaseDate: Driver<Int>
    var calendarHeaderViewModel: CalendarHeaderViewModel
  }
  
  var output: Output
  
  // MARK: - Private
  private let calendarUseCase: CalendarUseCase
  private var disposeBag = DisposeBag()
  
  // MARK: - init
  
  init(calendarUseCase: CalendarUseCase) {
    let daysBehaviorRelay = BehaviorRelay<[Day]>(value: [])
    self.calendarUseCase = calendarUseCase
    let numberOfWeeksInBaseDate = BehaviorRelay<Int>(value: self.calendarUseCase.numberOfWeeksInBaseDate)
    
    self.calendarUseCase.generateDaysInMonth(for: Date())
      .bind(to: daysBehaviorRelay)
      .disposed(by: disposeBag)
    
    self.output = Output(days: daysBehaviorRelay.asDriver(onErrorJustReturn: []),
                         numberOfWeeksInBaseDate: numberOfWeeksInBaseDate.asDriver(onErrorJustReturn: 0),
                         calendarHeaderViewModel: makeCalendarHeaderViewModel())
    self.input = Input()
    
    func makeCalendarHeaderViewModel() -> CalendarHeaderViewModel {
      return CalendarHeaderViewModel(baseDate: Date())
    }
    
    
  }
  
}
