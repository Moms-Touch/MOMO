//
//  customNavigationManager.swift
//  MOMO
//
//  Created by abc on 2021/12/18.
//
// CustomerNavigationManager는 다양한 방법의 presentation style을 보여주기 위한 매니저이다.

import Foundation
import UIKit

// Presentataion Direction을 통해서 어디서 올라오거나 나오는 present style을 만들수 있다.
enum PresentationDirection {
  case left
  case right
  case top
  case bottom
}

// UIViewControllerTransitioningDelegate을 채택하고 있기 떄문에 VC에서 delegate을 위임할때 self가
// 아닌 이 class로 주면 된다.
class CustomNavigationManager: NSObject, UIViewControllerTransitioningDelegate {
  
  var direction: PresentationDirection = .left
  
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let presentationController = CustomNavigationPresentationController(presentedViewController: presented, presenting: presenting, direction: direction)
    return presentationController
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CustomNavigationAnimator(direction: direction, isPresentation: true)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CustomNavigationAnimator(direction: direction, isPresentation: false)
  }
  
}
