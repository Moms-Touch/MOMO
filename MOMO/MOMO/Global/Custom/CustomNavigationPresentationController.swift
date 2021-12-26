//
//  CustomNavigationPresentationController.swift
//  MOMO
//
//  Created by abc on 2021/12/18.
//

import Foundation
import UIKit

final class CustomNavigationPresentationController: UIPresentationController {
  
  private var direction: PresentationDirection
  
  init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection) {
    self.direction = direction
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
  }
  
  // container layout 정하기
  override func containerViewWillLayoutSubviews() {
    switch direction {
    case .left:
      presentedView?.frame = frameOfPresentedViewInContainerView
    case .right:
      presentedView?.frame = frameOfPresentedViewInContainerView
    case .top:
      presentedView?.frame = frameOfPresentedViewInContainerView
    case .bottom:
      presentedView?.setRound([.topLeft, .topRight], radius: 22)
    }
  }
  
  // containerview 크기 정하기
  override var frameOfPresentedViewInContainerView: CGRect {
    var frame: CGRect = .zero
    frame.size = size(forChildContentContainer: presentedViewController,
                      withParentContainerSize: containerView!.bounds.size)
    switch direction {
    case .bottom:
      var presentedFrame: CGRect = .zero
      presentedFrame.origin.y = frame.size.height * 0.7
      presentedFrame.size = CGSize(width: frame.width, height: frame.height * 0.3)
      return presentedFrame
    default:
      return frame
    }
  }
}
