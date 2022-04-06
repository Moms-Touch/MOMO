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
  
  func save(diary: Diary) -> Observable<DiaryEntity> {
    return diaryDataStore.create(diary: diary)
      .map { return $0.toDomain() }
      .share()
  }
  
  func save(date: Date, emotion: DiaryEmotion, contentType: InputType, qnas: [QNA]) -> Observable<DiaryEntity> {
    let qnaList = List<QNA>()
    qnas.forEach { qnaList.append($0)}
    let diary = Diary(date: date, emotion: emotion, contentType: contentType, qnaList: qnaList)
    return diaryDataStore.create(diary: diary)
      .map { $0.toDomain() }
      .share()
  }
  
  func readDiaryDetail(date: Date) -> Observable<DiaryEntity?> {
    return diaryDataStore.read(date: date)
      .map {
        if let diary = $0 {
          return diary.toDomain()
        }
        return nil
      }
      .share()
  }
  
  func readEmotions(from fromDate: Date, to toDate: Date) -> Observable<[(Date, DiaryEmotion)]> {
    return diaryDataStore.read(from: fromDate, to: toDate)
      .map { diarys in
        return diarys.map { ($0.date, DiaryEmotion(rawValue: $0.emotion) ?? .unknown) }
      }
      .share()
  }
  
  func readEmotionInMonth(date: Date) -> Observable<[(Date, DiaryEmotion)]> {
    
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
        return diarys.map { ($0.date, DiaryEmotion(rawValue: $0.emotion) ?? .unknown) }
      }
      .share()
  }
  
  func delete(diary: DiaryEntity) -> Completable {
    return diaryDataStore.delete(diaryId: diary.id)
  }
  
  func updateDiary(with new: DiaryEntity) -> Observable<DiaryEntity> {
    
    let qnaList = List<QNA>()
    new.qnaList.forEach { tuple in
      qnaList.append(QNA(question: tuple.0, answer: tuple.1))
    }
    let diary = Diary(date: new.date, emotion: new.emotion, contentType: new.contentType, qnaList: qnaList)
    return diaryDataStore.update(with: diary)
      .map { $0.toDomain() }
      .share()
  }
  
  
}
