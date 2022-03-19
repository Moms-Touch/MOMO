//
//  UIView+Extension.swift
//  MOMO
//
//  Created by abc on 2021/11/13.
//

import UIKit
import RxSwift

extension UIView {
  
  // 모서리 둥글게
  func setRound(_ radius: CGFloat? = nil) {
    if let radius = radius {
      self.layer.cornerRadius = radius
    } else {
      self.layer.cornerRadius = self.bounds.height / 2
    }
    self.layer.masksToBounds = true
  }
  
  // 4방면에 border 주는 것
  func addBorder(_ arrEdge: [UIRectEdge], color: UIColor, width: CGFloat){
    for edge in arrEdge {
      let border = CALayer()
      switch edge {
      case UIRectEdge.top:
        border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
      case UIRectEdge.bottom:
        border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
      case UIRectEdge.left:
        border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
      case UIRectEdge.right:
        border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
      default:
        break
      }
      border.backgroundColor = color.cgColor
      self.layer.addSublayer(border)
    }
  }
  
  func setRound(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
  
  /*
   View에서도 Alert를 올릴 수 있도록 함
   */
  func alert(title: String, text: String?) -> Completable {
    return Completable.create { completable in
      let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction.cancelAction)
      alertVC.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
        completable(.completed)
      }))
      UIApplication.shared.windows.first{ $0.isKeyWindow}?.rootViewController?.presentedViewController?.present(alertVC, animated: true, completion: nil)
      return Disposables.create()
      }
    }
  
  func textfieldAlert(title: String, text: String?) -> Observable<String> {
    return Observable.create { observer in
      let alertVC = UIAlertController(title: title,
                                      message: text,
                                      preferredStyle: .alert)
      alertVC.addTextField()
      alertVC.addAction(UIAlertAction.cancelAction)
      alertVC.addAction(UIAlertAction(title: "네", style: .default,
                                      handler: { _ in
      observer.onNext(alertVC.textFields?[0].text ?? "")
      }))
      UIApplication.shared.windows.first{ $0.isKeyWindow}?.rootViewController?.presentedViewController?.present(alertVC, animated: true, completion: nil)
      return Disposables.create()
      }
    }
  
  func actionSheet(title: String, text: String?, contents: [String]) -> Observable<Int> {
    return Observable.create { observer in
      let actionSheet = UIAlertController(title: title,
                                          message: text,
                                          preferredStyle: .actionSheet)
      
      func makeAction() -> [UIAlertAction] {
        contents.enumerated().map { index, content in
          UIAlertAction(title: content, style: .default, handler: { _ in
            observer.onNext(index)
          })
        }
      }
      
      let actions = makeAction()
      actions.forEach { action in
        actionSheet.addAction(action)
      }
      actionSheet.addAction(UIAlertAction.cancelAction)
      
      UIApplication.shared.windows.first{ $0.isKeyWindow}?.rootViewController?.presentedViewController?.present(actionSheet, animated: true, completion: nil)
      return Disposables.create()
      
    }
  }
  
  func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
    UIApplication.shared.windows.first{ $0.isKeyWindow}?.rootViewController?.presentedViewController?.present(viewController, animated: animated, completion: completion)
  }
  
}


