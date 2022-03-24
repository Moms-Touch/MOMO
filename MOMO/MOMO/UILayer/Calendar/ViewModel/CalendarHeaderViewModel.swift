//
//  CalendarHeaderViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/25.
//

import Foundation
import RxCocoa
import RxSwift

final class CalendarHeaderViewModel: ViewModelType {
  
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
  
  // MARK: - Init
  
  init() {
    self.output = Output()
    self.input = Input()
  }
  
}
