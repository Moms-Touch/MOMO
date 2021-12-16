//
//  PopAnimator.swift
//  MOMO
//
//  Created by abc on 2021/11/27.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  private let duration = 0.3
  var presenting = true
  var originFrame = CGRect.zero
  
  var dismissCompletion: (()->Void)?
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let containerView = transitionContext.containerView
    let recommendCell = presenting ? transitionContext.view(forKey: .to)!: transitionContext.view(forKey: .from)!
    
    let initialFrame = presenting ? originFrame : recommendCell.frame
    let finalFrame = presenting ? recommendCell.frame : originFrame
    
    let xScaleFactor = presenting ?
      initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
    
    let yScaleFactor = presenting ?
      initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
    
    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    
    if presenting {
      recommendCell.transform = scaleTransform
      recommendCell.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
      recommendCell.clipsToBounds = true
    }
    
    if let toView = transitionContext.view(forKey: .to) {
      containerView.addSubview(toView)
    }
    containerView.bringSubviewToFront(recommendCell)
    
    UIView.animate(withDuration: duration) {
      recommendCell.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
      print(finalFrame)
      print(initialFrame)
      print("finalFrame.midx, midy", finalFrame.midX, finalFrame.midY)
      print("initical.midx, midy", initialFrame.midX, initialFrame.midY)
      recommendCell.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
    } completion: { _ in
      if !self.presenting {
        self.dismissCompletion?()
      }
      transitionContext.completeTransition(true)
    }
    
  }
  
  
}
