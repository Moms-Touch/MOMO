//
//  CalendarViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/24.
//

import Foundation
import RxSwift
import RxCocoa

class CalendarViewModel: ViewModelType {
  
  // MARK: - Input
  struct Input {
    
  }
  
  var input: Input
  
  // MARK: - Output
  struct Output {
    
  }
  
  var output: Output
  
  // MARK: - Private
  
  private var disposeBag = DisposeBag()
  
  // MARK: - init
  
  init() {
    self.output = Output()
    self.input = Input()
  }
  
}
