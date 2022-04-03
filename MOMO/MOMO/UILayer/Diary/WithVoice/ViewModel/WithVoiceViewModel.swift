//
//  WithVoiceViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/30.
//

import Foundation

import RxSwift
import OrderedCollections
import RxCocoa

protocol VoiceRecordable {
  var usecase: Recoder { get set }
  var qnaListBehaviorRelay: BehaviorRelay<[String: String]> { get set }
  var baseDate: Date { get }
}

class WithVoiceViewModel: WithInputViewModel, ViewModelType, VoiceRecordable {
  
  
  
  // MARK: - Input
  
  struct Input {
    
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var datasource: Driver<[String]>
    var questionCount: Driver<Int>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  var usecase: Recoder
  var baseDate: Date
  private var qnaList: OrderedDictionary<String, String> = [:]
  var qnaListBehaviorRelay: BehaviorRelay<[String : String]>
  private var defaultQuestion = "자유롭게 일기를 작성해주세요."
  private var guideQuestionList: [String] = [ "오늘 하루는 어떠셨나요?",
                                      "오늘 아이에게 무슨 일이 있었나요?",
                                      "남기고 싶은 말이 있나요?"
  ]
  private var content: DiaryContentMakeable
  
  // MARK: - init
  init(hasGuide: Bool, baseDate: Date, usecase: Recoder, content: DiaryContentMakeable) {
    self.content = content
    self.usecase = usecase
    self.baseDate = baseDate
    self.qnaListBehaviorRelay = BehaviorRelay<[String:String]>(value: [:])
    
    let datasource = hasGuide == true ? BehaviorRelay<[String]>(value: guideQuestionList) : BehaviorRelay<[String]>(value: [defaultQuestion])
    let questionCount = BehaviorRelay<Int>(value: 1)
    
    datasource
      .map{ $0.count }
      .bind(to: questionCount)
      .disposed(by: disposeBag)
    
    self.input = Input()
    self.output = Output(datasource: datasource.asDriver(), questionCount: questionCount.asDriver())
    super.init(hasGuide: hasGuide)
    
    datasource
      .withUnretained(self)
      .map { vm, questions -> [String: String] in
        var dic = [String:String]()
        questions.forEach { question in
          dic.updateValue("", forKey: question)
          vm.qnaList.updateValue("", forKey: question)
        }
        return dic
      }
      .bind(to: qnaListBehaviorRelay)
      .disposed(by: disposeBag)
    
    qnaListBehaviorRelay
      .map { dic -> (String, String)? in
        if let key = dic.keys.first, let value = dic[key] {
          return (String(key), value)
        }
        return nil
      }
      .compactMap { $0 }
      .withUnretained(self)
      .map({ (vm, tuple) -> [(String, String)] in
        vm.qnaList.updateValue(tuple.1, forKey: tuple.0)
        var contents: [(String, String)] = []
        vm.qnaList.forEach { contents.append($0) }
        return contents
      })
      .bind(to: content.content)
      .disposed(by: disposeBag)
    
    
  }

}
