//
//  CalendarHeaderViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/25.
//

import Foundation
import RxCocoa
import RxSwift

final class CalendarHeaderViewModel: ViewModelType {
  
  // MARK: - Input
  struct Input {
    var dayNumber: AnyObserver<Int>
    var nextMonthClick: AnyObserver<Void>
    var previousMonthClick: AnyObserver<Void>
    var closeButtonClick: AnyObserver<Void>
  }
  
  var input: Input
  
  // MARK: - Output
  struct Output {
    var dayLetter: Driver<(Int, String)>
    var month: Driver<String>
    var closeView: Driver<Void>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private var baseDate: Date
  
  // MARK: - Init
  
  init(baseDate: Date) {
  
    let dayNumberPublishSubject = PublishSubject<Int>()
    let dayLetterBehaviorRelay = BehaviorRelay<(Int, String)>(value: (0, ""))
    let monthBehaviorRelay = BehaviorRelay<String>(value: "2021.7")
    let nextMonthClick = BehaviorSubject<Void>(value: ())
    let previousMonthClick = BehaviorSubject<Void>(value: ())
    let closeButtonClick = BehaviorSubject<Void>(value: ())
    let closeView = BehaviorRelay<Void>(value: ())
    let calender = Calendar(identifier: .gregorian)
      
    self.baseDate = baseDate
    self.output = Output(
        dayLetter: dayLetterBehaviorRelay.asDriver(onErrorJustReturn: (0, "")),
        month: monthBehaviorRelay.asDriver(onErrorJustReturn: "2021.7"),
        closeView: closeView.asDriver(onErrorJustReturn: ())
    )
    self.input = Input(dayNumber: dayNumberPublishSubject.asObserver(), nextMonthClick: nextMonthClick.asObserver(), previousMonthClick: previousMonthClick.asObserver(), closeButtonClick: closeButtonClick.asObserver())
    
    monthBehaviorRelay.accept(self.baseDate.toString(format: "yyyy.M"))
  
    
    // MARK: - Input -> Output
    
    closeButtonClick
      .bind(to: closeView)
      .disposed(by: disposeBag)
    
    nextMonthClick.withLatestFrom(monthBehaviorRelay)
      .debug()
      .map {
        var date = $0.toDate(format: "yyyy.M") ?? Date()
        date = calender.date(byAdding: .month, value: 1, to: date) ?? Date()
        return date.toString(format: "yyyy.M")
         }
      .debug()
      .bind(to: monthBehaviorRelay)
      .disposed(by: disposeBag)
      
    previousMonthClick.withLatestFrom(monthBehaviorRelay)
      .debug()
      .map {
        var date = $0.toDate(format: "yyyy.M") ?? Date()
        date = calender.date(byAdding: .month, value: -1, to: date) ?? Date()
        return date.toString(format: "yyyy.M")
         }
      .bind(to: monthBehaviorRelay)
      .disposed(by: disposeBag)
      
    let right = dayNumberPublishSubject
      .withUnretained(self)
      .map{ $0.dayOfWeekLetter(for:$1) }
    
    let left = dayNumberPublishSubject
      .map { $0 - 1}
      
    Observable.zip(left, right)
      .bind(to: dayLetterBehaviorRelay)
      .disposed(by: disposeBag)
    
  }
  
  // MARK: - Private Methods
  
  private func dayOfWeekLetter(for dayNumber: Int) -> String {
    switch dayNumber {
    case 1:
      return "SUN"
    case 2:
      return "MON"
    case 3:
      return "TUE"
    case 4:
      return "WED"
    case 5:
      return "THU"
    case 6:
      return "FRI"
    case 7:
      return "SAT"
    default:
      return ""
    }
  }
  
}
