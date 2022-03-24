//
//  MonthMetadata.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/24.
//

import Foundation

struct MonthMetadata {
  let numberOfDays: Int // 달의 날짜 수 (30?, 31?, 28?)
  let firstDay: Date // 달의 첫날
  let firstDayWeekday: Int // 첫날의 요일
}
