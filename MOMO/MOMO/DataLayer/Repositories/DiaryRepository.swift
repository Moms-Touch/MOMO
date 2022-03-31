//
//  DairyRepository.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/25.
//

import Foundation
import RxSwift

protocol DiaryRepository {
  
  @discardableResult
  func readDiaryDetail(date: Date) -> Observable<Diary?>
  
  @discardableResult
  func readEmotionInMonth(date: Date) -> Observable<[(Date, DiaryEmotion)]>
  
  @discardableResult
  func readEmotions(from fromDate: Date, to toDate: Date) -> Observable<[(Date, DiaryEmotion)]>
  
  @discardableResult
  func delete(diary: Diary) -> Completable
  
  @discardableResult
  func updateDiary(with new: Diary) -> Observable<Diary>
  
  @discardableResult
  func save(diary: Diary) -> Observable<Diary>
}
