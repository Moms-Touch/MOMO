//
//  PresentationController.swift
//  MOMO
//
//  Created by abc on 2021/11/27.
//

import Foundation
import UIKit

class PresentationController: UIPresentationController {
  
  override var frameOfPresentedViewInContainerView: CGRect {
    var presentedViewFrame: CGRect = .zero
    let containerBounds = containerView!.bounds
    
    presentedViewFrame.origin.y = containerBounds.size.height * 0.7
    presentedViewFrame.size = CGSize(width: containerBounds.width, height: containerBounds.height * 0.3)
    return presentedViewFrame
  }
  
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
  }
  
  override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    presentedView!.setRound([.topLeft, .topRight], radius: 22)
  }
  
  
}
