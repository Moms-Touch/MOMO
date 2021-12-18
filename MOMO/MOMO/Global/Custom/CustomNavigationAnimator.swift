//
//  CustomNavigationAnimator.swift
//  MOMO
//
//  Created by abc on 2021/12/18.
//

import Foundation
import UIKit

final class CustomNavigationAnimator: NSObject {
  
  private let direction: PresentationDirection
  
  let isPresentation: Bool
  
  init(direction: PresentationDirection, isPresentation: Bool) {
    self.direction = direction
    self.isPresentation = isPresentation
    super.init()
  }
  
}

extension CustomNavigationAnimator: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
    
    guard let controller = transitionContext.viewController(forKey: key)
        else { return }
    
    if isPresentation {
      transitionContext.containerView.addSubview(controller.view)
    }
    let presentedFrame = transitionContext.finalFrame(for: controller)
    var dismissFrame = presentedFrame
    dismissFrame.origin.x = -presentedFrame.width
    
    let initialFrame = isPresentation ? dismissFrame : presentedFrame
    let finalFrame = isPresentation ? presentedFrame : dismissFrame
    
    let animationDuration = transitionDuration(using: transitionContext)
    controller.view.frame = initialFrame
    UIView.animate(
        withDuration: animationDuration,
        animations: {
          controller.view.frame = finalFrame
      }, completion: { finished in
        if !self.isPresentation {
          controller.view.removeFromSuperview()
        }
        transitionContext.completeTransition(finished)
      })

  }
  
  
  
  
  
}
