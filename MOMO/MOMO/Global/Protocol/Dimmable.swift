//
//  Dimmable.swift
//  MOMO
//
//  Created by abc on 2021/11/27.
//

import Foundation
import UIKit

enum Direction {case In, Out}

// Dimmable이라는 protocol은 흐리게 만들고 싶은 VC에 채택을 시켜주면된다.
// 그리고 dim이라는 함수를 쓰고 .In은 흐르게 만들어주는 것이고, .Out은 흐리게 해준 view를 없애는 효과

protocol Dimmable { }

extension Dimmable where Self: UIViewController {
  func dim(direction: Direction, color: UIColor = .black, alpha: CGFloat = 0.0, speed: Double = 0.0) {
    switch direction {
    case .In:
      let dimView = UIView(frame: view.frame)
      dimView.backgroundColor = color
      dimView.alpha = 0.0
      view.addSubview(dimView)
       
      //autolayout
      dimView.translatesAutoresizingMaskIntoConstraints = false
      dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      dimView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      
      //alpha effect
      UIView.animate(withDuration: speed) {
        dimView.alpha = alpha
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
