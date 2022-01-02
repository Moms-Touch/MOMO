//
//  VoiceView.swift
//  MOMO
//
//  Created by Woochan Park on 2022/01/02.
//

import UIKit

final class VoiceView: UIView, NibInstantiatable {

  @IBOutlet weak var playButton: UIButton!
  
  static func make() -> VoiceView {
    
    let view = Self.instantiateFromNib() as! VoiceView
    
    return view
  }
  
}
