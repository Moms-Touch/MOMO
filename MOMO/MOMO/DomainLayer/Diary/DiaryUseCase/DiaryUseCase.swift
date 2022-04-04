//
//  CreateDiaryUseCase.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/31.
//

import Foundation
import RxSwift

protocol DiaryUseCase {
  func saveDiary(date: Date, emotion: DiaryEmotion, contentType: InputType, qnas: [(String, String)]) -> Observable<Diary>
  func fetchDiary(date: Date) -> Observable<DiaryEntity?>
  func deleteDiary(diary: DiaryEntity) -> Completable
}

final class MomoDiaryUseCase: DiaryUseCase {
  
  private let repository: DiaryRepository
  private let realmCoder: RealmCoder
  
  init(repository: DiaryRepository, realmCoder: RealmCoder) {
    self.repository = repository
    self.realmCoder = realmCoder
  }
  
  func deleteDiary(diary: DiaryEntity) -> Completable {
    return repository.readDiaryDetail(date: diary.date)
      .compactMap { $0 }
      .withUnretained(self)
      .flatMap { usecase, diary -> Completable in
        return usecase.repository.delete(diary: diary)
      }
      .asCompletable()
  }
  
  func fetchDiary(date: Date) -> Observable<DiaryEntity?> {
    
    return repository
      .readDiaryDetail(date: date.timeToZero())
      .withUnretained(self)
      .map { usecase, diary -> DiaryEntity? in

        if let diary = diary {
          return usecase.realmCoder.decode(diary: diary)
        }
        return nil
      }
    
  }

  func saveDiary(date: Date, emotion: DiaryEmotion, contentType: InputType, qnas: [(String, String)]) -> Observable<Diary> {
    
    let qnaList = qnas.map { qnaTuple in
      QNA(question: qnaTuple.0, answer: qnaTuple.1)
    }
    return repository.save(date: date, emotion: emotion, contentType: contentType, qnas: qnaList)
  }
  
  
}
