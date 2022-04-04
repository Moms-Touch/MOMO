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
  var recoder: Recoder { get set }
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
  var recoder: Recoder
  var baseDate: Date
  var qnaListBehaviorRelay: BehaviorRelay<[String : String]>
  private var content: DiaryContentMakeable
  
  // MARK: - init
  init(hasGuide: Bool, baseDate: Date, recoder: Recoder, content: DiaryContentMakeable) {
    self.content = content
    self.recoder = recoder
    self.baseDate = baseDate
    self.qnaListBehaviorRelay = BehaviorRelay<[String:String]>(value: [:])
    
    let datasource =  BehaviorRelay<[String]>(value: [])
    let questionCount = BehaviorRelay<Int>(value: 1)
    
    datasource
      .map{ $0.count }
      .bind(to: questionCount)
      .disposed(by: disposeBag)
    
    self.input = Input()
    self.output = Output(datasource: datasource.asDriver(), questionCount: questionCount.asDriver())
    super.init(hasGuide: hasGuide)
    
    datasource.accept( hasGuide == true ? guideQuestionList : [defaultQuestion])

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
