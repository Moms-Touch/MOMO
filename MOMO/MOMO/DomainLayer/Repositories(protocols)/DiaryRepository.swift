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
  func readDiaryDetail(date: Date) -> Observable<DiaryEntity?>
  
  @discardableResult
  func readEmotionInMonth(date: Date) -> Observable<[(Date, DiaryEmotion)]>
  
  @discardableResult
  func readEmotions(from fromDate: Date, to toDate: Date) -> Observable<[(Date, DiaryEmotion)]>
  
  @discardableResult
  func delete(diary: DiaryEntity) -> Completable
  
  @discardableResult
  func updateDiary(with new: DiaryEntity) -> Observable<DiaryEntity>
  
  @discardableResult
  func save(diary: Diary) -> Observable<DiaryEntity>
  
  @discardableResult
  func save(date: Date, emotion: DiaryEmotion, contentType: InputType, qnas: [QNA]) -> Observable<DiaryEntity>

}
