//
//  CollectionViewCellPresentationController.swift
//  MOMO
//
//  Created by abc on 2021/11/27.
//

import UIKit

class CollectionViewCellPresentationController: UIPresentationController {
  
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
  }
  
  override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    presentedView!.setRound([.topLeft, .topRight], radius: 22)
  }

}
