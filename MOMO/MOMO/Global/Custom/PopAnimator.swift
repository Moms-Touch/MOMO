//
//  PopAnimator.swift
//  MOMO
//
//  Created by abc on 2021/11/27.
//

import UIKit

fileprivate let transitionDurationTime: TimeInterval = 1.0

enum PresentingType {
  case present
  case dismiss
}

class PopAnimator: NSObject {
  let presentingType: PresentingType
  
  init(presentingType: PresentingType) {
    self.presentingType = presentingType
    super.init()
  }
}

extension PopAnimator: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return transitionDurationTime
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
  }
}

extension PopAnimator {
  func animationForPresent(using transitionContext: UIViewControllerContextTransitioning) {
    
    let containerView = transitionContext.containerView
    
    guard let fromVC = transitionContext.viewController(forKey: .from) as? UITabBarController else {return}
    guard let toVC = transitionContext.viewController(forKey: .to) as? SettingWebViewController else {return}
    
//    guard let selectedCell = fromVC.selectedCell else {return}
    
//    let frame = selectedCell.convert(selectedCell.thumbNailImageView.frame, to: fromVC.view)
    
//    toVC.view.frame = frame
    toVC.view.layer.cornerRadius = 10
    
    containerView.addSubview(toVC.view)
  }
  
  func animationForDismiss(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: .from) as? SettingWebViewController else {return}
    guard let toVC = transitionContext.viewController(forKey: .to) as? TabBar else {return}
//    guard let selectedCell = mainVC.
    
    UIView.animate(withDuration: transitionDurationTime / 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
      
    }) {_ in
      
    }
  }
  
}
