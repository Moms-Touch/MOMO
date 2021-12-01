//
//  alertContainer.swift
//  MOMO
//
//  Created by abc on 2021/11/29.
//

import Foundation
import UIKit

protocol AlertContainer {
  var data: SimpleAlertModel? {get set}
  var note: UILabel {get set}
}

extension AlertContainer where Self: UITableViewCell {
  
  func contentChange() {
    guard let data = data else {return}
    switch data.alertType {
    case .alert:
      note.text = "\(data.title) 게시글에 대한 댓글이 달렸습니다. \(data.content)"
    case .message:
      note.text = "\(data.title)로부터 쪽지가 왔습니다. \(data.content)"
    }
  }
}

