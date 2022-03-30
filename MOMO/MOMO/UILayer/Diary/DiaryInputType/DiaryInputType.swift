//
//  DiaryInputType.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/29.
//

import Foundation

enum InputType: String {
  case text
  case voice
}


struct DiaryInputType {
  
  var inputType: InputType
  var hasGuide: Bool?
}

enum InputOptionErrorType: Error {
  
  case unspecifiedButton
}
