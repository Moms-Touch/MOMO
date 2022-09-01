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
  func generateDaysInMonth(for baseDate: Date) -> Observable<[Day]>
  var numberOfWeeksInBaseDate: Int { get }
}

enum CalendarDataError: Error {
  case metadataGeneration
}

final class MomoCalendarUseCase: CalendarUseCase {
  
  // MARK: - Dependencies
  private let repository: DiaryRepository
  private var selectedDate: Date
  private var baseDate: Date
  
  // MARK: - Private properties
  private var disposeBag = DisposeBag()
  
  // MARK: - init
  
  init(repository: DiaryRepository, baseDate: Date) {
    self.repository = repository
    self.selectedDate = baseDate
    self.baseDate = baseDate
  }
  
  var numberOfWeeksInBaseDate: Int {
    return calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
  }
  
  // MARK: - Methods
  
  func generateDaysInMonth(for baseDate: Date) -> Observable<[Day]> {
    
    guard let metadata = try? monthMetadata(for: baseDate) else {
      fatalError("\(baseDate)가 애러를 발생시킴")
    }
    
    let numberOfDaysInMonth = metadata.numberOfDays
    let offSetInInitialRow = metadata.firstDayWeekday
    let firstDayOfMonth = metadata.firstDay

    //만약에 month가 sunday부터 시작을 하지 않는 이상, 전달의 days가 앞에 붙게 된다. 이를 해결하기위해서 range를 만드는데,
    // 예를 들어, Friday에서부터 시작하면, offsetInInitailRow가 추가의 5일을 부텨줄것이다. 그리고 map을 사용해서 [Day]로 range를 변경해준다
    
    var days: [Day] = (1..<(numberOfDaysInMonth + offSetInInitialRow))
      .map { day in
        let isWithinDisplayedMonth = day >= offSetInInitialRow
        
        // 달의 첫날과의 거리를 찾는다. 음수가 나오면 현재달에 없다는 것 이때는 -을 붙인다.
        let dayOffset = isWithinDisplayedMonth ? day - offSetInInitialRow : -(offSetInInitialRow - day)
        
        return generatedDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
      }
      
    days += generateStartOfNextMonth(using: firstDayOfMonth)
  
    // days는 기본Emotion은 .unknown임, readEmotion을 통해서 기간동안의 date를 가져오고, 이를 통해서 기본 days에 date를 비교한뒤에 변경한다.
    return self.repository.readEmotions(from: days.first!.date, to: days.last!.date)
      .map { arr  -> [Day] in
        var newDays = days
        arr.forEach { (date, mood) in
          if let index = newDays.firstIndex(where: { $0.date == date}) {
            newDays[index].mood = mood
          }
        }
        return newDays
      }
      .share()

  }
  
  
  // MARK: - Private properties
  private var calendar = Calendar(identifier: .gregorian)
  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter
  }()

  // MARK: - Private Methods
  
  // 그 달의 메타데이터를 구한다
  private func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
    guard let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count, let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate)) else {
      throw CalendarDataError.metadataGeneration
    }
    
    let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth) // 첫째날이 무슨요일인지 구하는것은 앞에 요일을 붙여주기 위한 과정
    
    return MonthMetadata(numberOfDays: numberOfDaysInMonth, firstDay: firstDayOfMonth, firstDayWeekday: firstDayWeekday)
    
  }
  
  // 달의 첫날로부터 거리를 더하거나 빼서 day를 방출한다.
  private func generatedDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
    let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
    
    return Day(date: date, number: dateFormatter.string(from: date), isSelected: calendar.isDate(date, inSameDayAs: selectedDate), isWithDisplayMonth: isWithinDisplayedMonth, mood: .unknown)
    
  }
  
  // 마지막날이 토요일로 끝나지 않는 이상, 다음 날의 것도 날짜를 가져와서 뒤에붙여준다.
  private func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
    
    guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfDisplayedMonth) else {return []}
    
    let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
    // 토요일로 끝났으면 return []
    guard additionalDays > 0 else {return []}
    
    let days: [Day] = (1...additionalDays)
      .map { generatedDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false)}
    
    return days
  }
  
}

