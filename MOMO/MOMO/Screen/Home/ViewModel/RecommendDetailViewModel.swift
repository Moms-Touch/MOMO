//
//  RecommendDetailViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/22.
//

import Foundation
import RxSwift

class RecommendDetailViewModel: ViewModelType {
  
  // MARK: Input
  
  struct Input {
    
  }
  
  var input: Input
  
  // MARK: Output
  
  struct Output {
    
  }
  
  var output: Output
  
  // Private Properities
  private var disposeBag = DisposeBag()
  
  init() {
    
    self.input = Input()
    self.output = Output()
  }
  
  
  
}
