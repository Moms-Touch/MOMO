//
//  CalendarUserCase.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol CalendarUseCase {
  func monthMetadata(for baseDate: Date) -> Observable<MonthMetadata>
  func generateDaysInMonth(for baseDate: Date) -> Observable<[Day]>
}

final class MomoCalendarUseCase: CalendarUseCase {
  
  // MARK: - Dependencies
  
  // MARK: - init
  
  init() {
    
  }
  
  // MARK: - Methods
  
  func monthMetadata(for baseDate: Date) -> Observable<MonthMetadata> {
    return Observable.empty()
  }
  
  func generateDaysInMonth(for baseDate: Date) -> Observable<[Day]> {
    return Observable.empty()
  }
  
  
  // MARK: - Private properties
  private var calendar = Calendar(identifier: .gregorian)
  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter
  }()

  // MARK: - Private Methods
  
  // 달의 첫날로부터 거리를 더하거나 빼서 day를 방출한다.
  private func generatedDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
    let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
    
    return Day(date: date, number: "", isSelected: true, isWithDisplayMonth: true, mood: nil)
  }
  
}
