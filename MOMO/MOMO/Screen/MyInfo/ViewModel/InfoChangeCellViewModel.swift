//
//  InfoChangeCellViewModel.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation

class InfoChangeCellViewModel: InfoCellViewModel, ViewModelType {
  
  //MARK: - Input

  struct Input {
    
  }
  
  var input: Input

  //MARK: - Output
  
  struct Output {
    
  }
  
  var output: Output
  
  //MARK: - Private properties
  private var content: [String]
  
  //MARK: - Init

  init(index: Int, content: [String]) {
    self.output = Output()
    self.input = Input()
    self.content = content
    super.init(index: index)
  }


  
  
}
