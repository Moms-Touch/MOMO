//
//  MyInfoViewModel.swift
//  MOMO
//
//  Created by abc on 2022/03/12.
//

import Foundation
import RxSwift
import RxCocoa

class MyInfoCellViewModel: InfoCellViewModel, ViewModelType {
  
  //MARK: - Input
  struct Input {
    
  }
  
  var input: Input
  
  //MARK: - OutPut

  struct Output {
    var email: Driver<String?>
    var nick: Driver<String?>
    var description: Driver<String>
  }

  var output: Output
  
  //MARK: - private

  private var disposeBag = DisposeBag()
  
  //MARK: - init
  
  init(index: Int, email:BehaviorRelay<String?>, nickname: BehaviorRelay<String?>, description: BehaviorRelay<String>) {
    self.output = Output(email: email.asDriver(onErrorJustReturn: nil), nick: nickname.asDriver(onErrorJustReturn: nil), description: description.asDriver(onErrorJustReturn: "대한민국에 사는 엄마"))
    self.input = Input()
    super.init(index: index)
  }
  
}
