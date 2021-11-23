//
//  RecommendModalViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit
import PanModal

class RecommendModalViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .blue
    // Do any additional setup after loading the view.
  }
  
}

extension RecommendModalViewController: PanModalPresentable {
  var panScrollable: UIScrollView? {
    return nil
  }
  
  var shortFormHeight: PanModalHeight {
    return .contentHeight(200)
  }
  
  var longFormHeight: PanModalHeight {
    return .maxHeightWithTopInset(400)
  }
  
  var panModalBackgroundColor: UIColor {
    return .black.withAlphaComponent(0.2)
  }
  
  var showDragIndicator: Bool {
    return true
  }
  
  var isUserInteractionEnabled: Bool {
    return true
  }
}
