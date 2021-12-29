//
//  BabyInfoViewModel.swift
//  MOMO
//
//  Created by abc on 2021/12/29.
//

import Foundation

struct BabyInfoViewModel {
  
  var model: BabyData?
  
  var babyImageUrl: String {
    return model?.imageURL ?? "default"
  }
  
  var babyName: String {
    return model?.name ?? "아기이름"
  }
  
  var babyBirth: String {
    if let birth = model?.birth {
      return birth.trimStringDate()
    } else {
      return "출생일/출생예정일"
    }
  }
}
