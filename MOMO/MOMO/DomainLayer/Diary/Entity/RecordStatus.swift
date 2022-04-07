//
//  RecordStatus.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/01.
//

import Foundation
import UIKit

enum RecordStatus {
  case notstarted
  case recording
  case finished
  
  var image: UIImage? {
    switch self {
    case .notstarted:
      return UIImage(named: "micOn")
    case .recording:
      return UIImage()
    case .finished:
      return UIImage(named: "end")
    }
  }
}
