//
//  WithVoiceViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/30.
//

import Foundation

class WithVoiceViewModel: ViewModelType {
  struct Input {}
  var input: Input
  struct Output {}
  var output: Output
  init() {
    self.input = Input()
    self.output = Output()
  }
}
