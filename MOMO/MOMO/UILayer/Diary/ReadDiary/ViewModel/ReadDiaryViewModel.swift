//
//  ReadDiaryViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/03.
//

import Foundation

import RxSwift
import RxCocoa

class ReadDiaryViewModel: ViewModelType {
  
  // MARK: - Input
  
  struct Input {
    
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  
  // MARK: - init
  init() {
    self.input = Input()
    self.output = Output()
  }

}
