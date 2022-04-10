//
//  UIViewController+Extension.swift
//  MOMO
//
//  Created by abc on 2022/03/15.
//

import UIKit
import RxSwift

extension UIViewController {
  func alert(title: String, text: String?) -> Completable {
    return Completable.create { [weak self] completable in
      let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction.cancelAction)
      alertVC.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
        completable(.completed)
      }))
      self?.present(alertVC, animated: true, completion: nil)
      return Disposables.create {
        self?.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  func alertWithOneAnswer(title: String, text: String?, answer: String) -> Completable {
    return Completable.create { [weak self] completable in
      let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: answer, style: .default, handler: { _ in
        completable(.completed)
      }))
      self?.present(alertVC, animated: true, completion: nil)
      return Disposables.create {
        self?.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  func alertWithObservable(title: String, text: String?) -> Observable<Bool> {
    return Observable.create { observer in
      let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction.cancelAction)
      alertVC.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
        observer.onNext(true)
      }))
     self.present(alertVC, animated: true, completion: nil)
      return Disposables.create()
    }
  }
  
  func keyboardHeight() -> Observable<CGFloat> {
    return Observable
      .from([
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
          .map { notification -> CGFloat in
            (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
          },
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
          .map { _ -> CGFloat in
            0
          }
      ])
      .merge()
  }
  
  
}
