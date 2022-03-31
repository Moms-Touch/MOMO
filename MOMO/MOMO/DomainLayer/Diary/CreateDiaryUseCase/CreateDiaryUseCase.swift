//
//  CreateDiaryUseCase.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/31.
//

import Foundation

import RxSwift
import RealmSwift

protocol CreateDiaryUseCase {
  func saveDiary(date: Date, emotion: DiaryEmotion, contentType: InputType, qnas: [(String, String)]) -> Observable<Diary>
}

final class MomoCreateDiaryUseCase: CreateDiaryUseCase {
  
  private let repository: DiaryRepository
  
  init(repository: DiaryRepository) {
    self.repository = repository
  }

  func saveDiary(date: Date, emotion: DiaryEmotion, contentType: InputType, qnas: [(String, String)]) -> Observable<Diary> {
    
    let qnaList = List<QNA>()
    qnas.forEach { qnaTuple in
      let qna = QNA(question: qnaTuple.0, answer: qnaTuple.1)
      qnaList.append(qna)
    }
    let diary = Diary(date: date, emotion: emotion, contentType: contentType, qnaList: qnaList)
    return repository.save(diary: diary).asObservable()
  }
  
  
}
