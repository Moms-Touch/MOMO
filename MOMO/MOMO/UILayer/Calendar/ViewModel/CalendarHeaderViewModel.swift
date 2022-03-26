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
  }
  
  var input: Input
  
  // MARK: - Output
  struct Output {
    var dayLetter: Driver<(Int, String)>
    var month: Driver<String>
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
      
    self.baseDate = baseDate
    self.output = Output(dayLetter: dayLetterBehaviorRelay.asDriver(onErrorJustReturn: (0, "")), month: monthBehaviorRelay.asDriver(onErrorJustReturn: "2021.7"))
    self.input = Input(dayNumber: dayNumberPublishSubject.asObserver())
    
    monthBehaviorRelay.accept(self.baseDate.toString(format: "yyyy.M"))
  
    
    // MARK: - Input -> Output
    
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
