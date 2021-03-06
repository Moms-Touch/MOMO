//
//  QnAView.swift
//  MOMO
//
//  Created by Woochan Park on 2022/01/01.
//

import UIKit

final class QnAView: UIView, NibInstantiatable {
  
  @IBOutlet weak var questionLabel: UILabel! {
    didSet {
      questionLabel.font = UIFont.customFont(forTextStyle: .title3)
    }
  }
  
  @IBOutlet weak var answerTextView: UITextView! {
    didSet {
      answerTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone))
      answerTextView.font = UIFont.customFont(forTextStyle: .body)
      answerTextView.isUserInteractionEnabled = false
      answerTextView.isAccessibilityElement = true
    }
  }
  
  static func make(question: String, answer: String) -> QnAView {
    
    let view = Self.instantiateFromNib()
    
    view.questionLabel.text = question
    
    view.answerTextView.text = answer
    
    view.isAccessibilityElement = false
    
    return view
  }
  
  @objc func tapDone(sender: Any) {
    self.answerTextView.endEditing(true)
  }
}
