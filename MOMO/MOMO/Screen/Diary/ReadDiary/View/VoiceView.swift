//
//  VoiceView.swift
//  MOMO
//
//  Created by Woochan Park on 2022/01/02.
//

import UIKit

final class VoiceView: UIView, NibInstantiatable {

  @IBOutlet weak var playButton: UIButton! {
    didSet {
      playButton.accessibilityLabel = "음성녹음 재생"
    }
  }
  
  static func make() -> VoiceView {
    
    let view = Self.instantiateFromNib() as! VoiceView
    view.isAccessibilityElement = false
    return view
  }
  
}
