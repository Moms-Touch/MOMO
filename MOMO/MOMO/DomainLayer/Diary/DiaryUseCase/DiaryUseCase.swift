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
  func fetchDiary(date: Date) -> Observable<Diary?>
}

final class MomoDiaryUseCase: DiaryUseCase {
  
  private let repository: DiaryRepository
  
  init(repository: DiaryRepository) {
    self.repository = repository
  }
  
  func fetchDiary(date: Date) -> Observable<Diary?> {
    return repository.readDiaryDetail(date: date.timeToZero())
  }

  func saveDiary(date: Date, emotion: DiaryEmotion, contentType: InputType, qnas: [(String, String)]) -> Observable<Diary> {
    
    let qnaList = qnas.map { qnaTuple in
      QNA(question: qnaTuple.0, answer: qnaTuple.1)
    }
    return repository.save(date: date, emotion: emotion, contentType: contentType, qnas: qnaList)
  }
  
  
}
