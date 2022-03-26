//
//  CalendarCellViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/26.
//

import Foundation
import RxSwift
import RxCocoa

final class CalendarCellViewModel: ViewModelType {
  
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
  
  // MARK: - Init
  
  init(day: BehaviorSubject<Day>) {
    
    self.output = Output()
    self.input = Input()
  }
  
}
