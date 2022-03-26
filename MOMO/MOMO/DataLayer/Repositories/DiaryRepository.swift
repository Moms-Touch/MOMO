//
//  DairyRepository.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/25.
//

import Foundation
import RxSwift

protocol DiaryRepository {
  func readDiaryDetail(date: Date) -> Observable<Diary?>
  func readEmotionInMonth(date: Date) -> Observable<[(Date, DiaryEmotion)]>
  func readEmotions(from fromDate: Date, to toDate: Date) -> Observable<[(Date, DiaryEmotion)]>
  func delete(diary: Diary) -> Completable
  func updateDiary(with new: Diary) -> Observable<Diary>
  func save(diary: Diary) -> Observable<Diary>
}