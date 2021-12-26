//
//  InfoViewModel.swift
//  MOMO
//
//  Created by abc on 2021/12/26.
//

import UIKit

class InfoDataViewModel {
  
  var model: InfoData?
  
  init(model: InfoData?) {
    self.model = model
  }
  
  var url: URL? {
    guard let model = model else {
      return nil
    }
    return URL(string: model.url)!
  }
  
  var thumbNailImageURL: URL? {
    guard let thumbnailImageURL = model?.thumbnailImageUrl else {return nil}
    return URL(string: thumbnailImageURL)!
  }
  
  var isbookMark: Bool {
    return false
  }
}
