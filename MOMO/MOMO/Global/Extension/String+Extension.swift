//
//  String+Extension.swift
//  MOMO
//
//  Created by abc on 2021/12/29.
//

import Foundation

extension String {
  //json 형식으로 들어오는 것을 string으로 변경
  func trimStringDate() -> String {
    return self.components(separatedBy: "T")[0].components(separatedBy: "-").joined(separator: ".")
  }
  
  func toDate() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    return dateFormatter.date(from: self)
  }
  
  // 임신중인 아이의 주차
  func fetusInWeek() -> String? {
    guard let date = self.toDate() else {
        return nil
    }
    let today = Date()
  
    guard let distanceDay = Calendar.current.dateComponents([.day], from: today, to: date).day else {
        return nil
    }
    print(distanceDay)
    print(distanceDay / 7)
    print(40 - (distanceDay / 7))
    // 40 - 버림((출산예정일 - 오늘) / 7)
    var distanceWeek = 40 - (distanceDay / 7)
    if distanceWeek < 0 {
      distanceWeek = 1
    }
    return "\(distanceWeek)주차"
  }
  
  // 태어난 아이의 주차
  func babyInWeek() -> String? {
    guard let date = self.toDate() else {
        return nil
    }
    let today = Date()
    var calendar = Calendar(identifier: .gregorian)
    calendar.firstWeekday = 2
    calendar.minimumDaysInFirstWeek = 4
    
    let dateInCal = calendar.dateComponents([.year, .month, .day], from: date)
    let todayInCal = calendar.dateComponents([.year, .month, .day], from: today)
    
    if todayInCal.year! > dateInCal.year! {
      return "\(todayInCal.year! - dateInCal.year! + 1)살"
    } else if todayInCal.year! == dateInCal.year! {
      let dateWeek = calendar.component(.weekOfYear, from: date)
      let todayWeek = calendar.component(.weekOfYear, from: today)
      return "\(todayWeek - dateWeek)주차"
    } else {
      return nil
    }
  }
  
  var isNotEmpty: Bool {
    return !self.isEmpty
  }
}
