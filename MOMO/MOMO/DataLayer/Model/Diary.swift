//
//  Diary.swift
//  MOMO
//
//  Created by Woochan Park on 2021/12/29.
//

import Foundation
import RealmSwift
import UIKit

class Diary: Object {
  
  @Persisted(primaryKey: true) var id: ObjectId
  
  /// 일기 작성 날짜
  @Persisted var date: Date
  
  /// 감정
  @Persisted var emotion: String
  
  /// 텍스트 인지 음성 인지
  @Persisted var contentType: String
  
  /// 질문 과 답변 목록
  /// 이 때 contentType 이 음성이라면 음성 파일의 URL path 가 들어 있다.
  @Persisted var qnaList: List<QNA>
  
  convenience init(date: Date, emotion: DiaryEmotion, contentType: DiaryInputType.InputType, qnaList: List<QNA>) {
    
    self.init()
    self.date = date.timeToZero()
    self.emotion = emotion.rawValue
    self.contentType = contentType.rawValue
    self.qnaList = qnaList
    
  }
}

/*
 한 쌍의 질문과 대답을 표현하는 Realm 모델
 음성의 경우 answer 에 음성파일의 경로가 들어있다
 */
class QNA: Object {
  
  @Persisted var question: String
  @Persisted var answer: String?
  
  convenience init(question: String, answer: String? = nil) {
    self.init()
    self.question = question
    self.answer = answer
  }
}

/*
 일기 중 감정 상태를 표현하는 열거형
 */

enum DiaryEmotion: String {
  
  case happy
  case angry
  case sad
  case blue
  case unknown
  
  var image: UIImage? {
    switch self {
    case .happy:
      return UIImage(named: "bird.happy")
    case .angry:
      return UIImage(named: "bird.angry")
    case .sad:
      return UIImage(named: "bird.sad")
    case .blue:
      return UIImage(named: "bird.blue")
    case .unknown:
      return nil
    }
  }
}
