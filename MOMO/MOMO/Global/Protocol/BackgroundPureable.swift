//
//  Dimmable.swift
//  MOMO
//
//  Created by abc on 2021/11/27.
//

import UIKit

// BackgroundPureable이라는 protocol은 흐리게 만들고 싶은 VC에 채택을 시켜주면된다.
// 그리고 BackgroundPureable이라는 함수를 쓰고 .In은 흐르게 만들어주는 것이고, .Out은 흐리게 해준 view를 없애는 효과

protocol BackgroundPureable { }

extension BackgroundPureable where Self: UIViewController {
  func pure(direction: Direction, alpha: CGFloat = 0.0, speed: Double = 0.0) {
    switch direction {
    case .In:
      let pureView = UIView(frame: view.frame)
      pureView.backgroundColor = UIColor(patternImage: UIImage(named: "mainBackground")!)
      pureView.alpha = 0.0
      view.addSubview(pureView)
       
      //autolayout
      pureView.translatesAutoresizingMaskIntoConstraints = false
      pureView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      pureView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      pureView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      pureView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      self.navigationController?.tabBarController?.tabBar.isHidden = true
      //alpha effect
      UIView.animate(withDuration: speed) {
        pureView.alpha = alpha
      }
      
    case .Out:
      UIView.animate(withDuration: speed) {
        self.view.subviews.last?.alpha = alpha ?? 0
      } completion: { finished in
        self.view.subviews.last?.removeFromSuperview()
      }

    }
  }
}

