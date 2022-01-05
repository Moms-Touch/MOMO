//
//  UINavigationController+Extension.swift
//  MOMO
//
//  Created by abc on 2022/01/05.
//

import Foundation
import UIKit

extension UINavigationController {
  func pushViewController(_ viewController :UIViewController, animated: Bool, completion: (() -> Void)?) {
    CATransaction.begin()
    CATransaction.setAnimationDuration(1)
    CATransaction.setCompletionBlock(completion)
    pushViewController(viewController, animated: true)
    CATransaction.commit()
  }
  
  func popToViewController(_ viewController :UIViewController, animated: Bool, completion: (() -> Void)?) {
    CATransaction.begin()
    CATransaction.setAnimationDuration(1)
    CATransaction.setCompletionBlock(completion)
    popToViewController(viewController, animated: true)
    CATransaction.commit()
  }
}

