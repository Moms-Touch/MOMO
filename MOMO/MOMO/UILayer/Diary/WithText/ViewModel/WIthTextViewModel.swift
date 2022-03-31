//
//  WIthTextViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/30.
//

import Foundation

import OrderedCollections
import RxSwift
import RxCocoa
import RealmSwift

protocol DiaryContentGetable {
  var qnaListBehaviorRelay: BehaviorRelay<[String:String]> { get set }
}

class WithTextViewModel: WithInputViewModel, ViewModelType, DiaryContentGetable {
  
  // MARK: - Input
  struct Input {
    
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var datasource: Driver<[String]>
    var qnaDic: Driver<[String: String]>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  
  private var qnaList: OrderedDictionary<String, String> = [:]
  private var defaultQuestion = "자유롭게 일기를 작성해주세요."
  private var guideQuestionList: [String] = [ "오늘 하루는 어떠셨나요?",
                                      "오늘 아이에게 무슨 일이 있었나요?",
                                      "남기고 싶은 말이 있나요?"
  ]
  private var disposeBag = DisposeBag()
  var qnaListBehaviorRelay: BehaviorRelay<[String:String]>
  private var content: DiaryContentMakeable

  init(hasGuide: Bool, baseDate: Date, content: DiaryContentMakeable) {
    
    let datasource = hasGuide == true ? BehaviorRelay<[String]>(value: guideQuestionList) : BehaviorRelay<[String]>(value: [defaultQuestion])
    self.qnaListBehaviorRelay = BehaviorRelay<[String:String]>(value: [:])
    self.content = content
    
    self.input = Input()
    self.output = Output(datasource: datasource.asDriver(), qnaDic: qnaListBehaviorRelay.asDriver())
    super.init(hasGuide: hasGuide)
    
    datasource
      .withUnretained(self)
      .map({ vm, questions in
        var dic = [String:String]()
        questions.forEach { question in
          dic.updateValue("", forKey: question)
          vm.qnaList.updateValue("", forKey: question)
        }
        return dic
      })
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
