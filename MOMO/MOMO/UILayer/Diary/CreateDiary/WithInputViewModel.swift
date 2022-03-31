//
//  WithInputViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/31.
//

import Foundation

// WithTextViewModel, WithVoiceViewModel의 부모viewmodel

class WithInputViewModel {
  private var hasGuide: Bool
  
  init(hasGuide: Bool) {
    self.hasGuide = hasGuide
  }
}
