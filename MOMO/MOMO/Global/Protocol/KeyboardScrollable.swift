//
//  KeyboardScrollable.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import UIKit

//MARK: 키보드스크롤러블 protocol
//Keyboard가 scrollview에서 쓰일때, 키보드가 올라왔을 때, 키보드 뒤에 있는 content를 scroll 할 수 있다

protocol KeyboardScrollable: Scrollable {
  func scrollingKeyboard()
}

extension KeyboardScrollable {
  func scrollingKeyboard() {
    let tapGesture = UITapGestureRecognizer(
      target: view,
      action: #selector(view.endEditing(_:)))
    
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
    
    NotificationCenter.default.addObserver(
      forName: UIResponder.keyboardWillShowNotification,
      object: nil,
      queue: OperationQueue.main) { (notification) in
        guard let userInfo = notification.userInfo else {
          return
        }
        guard let keyboardFrame =
                userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        
        let contentInset = UIEdgeInsets(
          top: 0.0,
          left: 0.0,
          bottom: keyboardFrame.size.height,
          right: 0.0
        )
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
                as? TimeInterval else {return}
        UIView.animate(withDuration: duration) {
          self.view.layoutIfNeeded()
        }
      }
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                           object: nil,
                                           queue: OperationQueue.main) { (notification) in
      guard let userInfo = notification.userInfo else {
        return
      }
      let contentInset = UIEdgeInsets.zero
      self.scrollView.contentInset = contentInset
      self.scrollView.scrollIndicatorInsets = contentInset
      guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
      UIView.animate(withDuration: duration) {
        self.view.layoutIfNeeded()
      }
    }
  }
}



