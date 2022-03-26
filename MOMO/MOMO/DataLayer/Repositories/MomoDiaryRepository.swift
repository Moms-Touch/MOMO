//
//  MomoDairyRepository.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/25.
//

import Foundation
import RxSwift
import RealmSwift

final class MomoDiaryRepository: DiaryRepository {
  
  private let diaryDataStore: DiaryDataStore
  
  init(diaryDataStore: DiaryDataStore) {
    self.diaryDataStore = diaryDataStore
  }
  
  // MARK: - Methods
  
  func save(diary: Diary) -> Observable<Diary> {
    return diaryDataStore.create(diary: diary)
  }
  
  func readDiaryDetail(date: Date) -> Observable<Diary> {
    return diaryDataStore.read(date: date)
  }
  
  func readEmotionInMonth(date: Date) -> Observable<[DiaryEmotion]> {
    
    let calendar = Calendar.current
    
    //달의 첫날
    guard let firstDayInMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) else {
      return Observable.error(DataStoreError.noResult)
    }
    
    //달의 마지막날
    guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayInMonth) else {
      return Observable.error(DataStoreError.noResult)
    }
    
    return diaryDataStore.read(from: firstDayInMonth, to: lastDayInMonth)
      .map { diarys in
        return diarys.map { DiaryEmotion(rawValue: $0.emotion) ?? .unknown}
      }
  }
  
  func delete(diary: Diary) -> Completable {
    return diaryDataStore.delete(diary: diary)
  }
  
  func updateDiary(with new: Diary) -> Observable<Diary> {
    return diaryDataStore.update(with: new)
  }
  
  
}
