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
}
