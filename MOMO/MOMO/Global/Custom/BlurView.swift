//
//  BlurView.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/30.
//

import UIKit

import SnapKit
import Then

class BlurView: UIView {

  private let backgroundView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "mainBackground")!
  }
  
  private let blurView = UIVisualEffectView().then {
    let blurEffect = UIBlurEffect(style: .systemThickMaterialLight)
    $0.effect = blurEffect
    $0.alpha = 0.55
  }
  
  override func layoutSubviews() {
    self.addSubview(backgroundView)
    self.addSubview(blurView)
    
    backgroundView.snp.makeConstraints { make in
      make.left.right.top.bottom.equalToSuperview()
    }
    
    blurView.snp.makeConstraints { make in
      make.left.right.top.bottom.equalToSuperview()
    }
  }

}
