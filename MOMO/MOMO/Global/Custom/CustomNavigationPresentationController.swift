//
//  CustomNavigationPresentationController.swift
//  MOMO
//
//  Created by abc on 2021/12/18.
//

import Foundation
import UIKit

class CustomNavigationPresentationController: UIPresentationController {
  
  private var direction: PresentationDirection
  
  init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection) {
    self.direction = direction
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
  }
  
  override func containerViewWillLayoutSubviews() {
    presentedView?.frame = frameOfPresentedViewInContainerView
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
    var frame: CGRect = .zero
    frame.size = size(forChildContentContainer: presentedViewController,
                      withParentContainerSize: containerView!.bounds.size)
    
    return frame
  }
  
  
  
}
