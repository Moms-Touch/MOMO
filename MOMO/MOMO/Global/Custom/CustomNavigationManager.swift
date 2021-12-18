//
//  customNavigationManager.swift
//  MOMO
//
//  Created by abc on 2021/12/18.
//

import Foundation
import UIKit

enum PresentationDirection {
  case left
  case right
  case top
  case bottom
}

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
