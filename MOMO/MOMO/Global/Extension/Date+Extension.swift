//
//  Date+Extension.swift
//  MOMO
//
//  Created by abc on 2021/11/15.
//

import Foundation

extension Date {
  func toString(format: String = "yyyy.MM.dd") -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = format
    let dateStr = formatter.string(from: self)
    return dateStr
  }
  
  /*
   시와 분을 날리고, [년 월 일] 만 남긴다
   결과적으로 00 시 00 분을 가진 날짜가 된다.
   
   사용 예: Date().timeToZero()
   */
  func timeToZero() -> Date {
    
    var calendar = Calendar.current
    
    calendar.locale = Locale(identifier: "kr_KR")
    
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
    
    return calendar.date(from: dateComponents)!
  }
}
