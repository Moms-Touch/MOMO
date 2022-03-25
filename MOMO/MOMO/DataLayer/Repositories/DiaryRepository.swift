//
//  DairyRepository.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/25.
//

import Foundation
import RxSwift

protocol DiaryRepository {
  func readEmotionInMonth(date: Date) -> Observable<[DiaryEmotion]>
}
