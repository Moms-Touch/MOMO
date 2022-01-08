//
//  WithTextCollectionViewCell.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/27.
//

import UIKit

class WithTextCollectionViewCell: UICollectionViewCell, NibInstantiatable {
  
  static var identifier = String(describing: self)
  
  @IBOutlet weak var questionLabel: UILabel! {
    didSet {
      questionLabel.font = UIFont.customFont(forTextStyle: .title3)
    }
  }
  
  @IBOutlet weak var answerTextView: UITextView! {
    didSet {
      answerTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone))
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  @objc func tapDone(sender: Any) {
    self.answerTextView.endEditing(true)
  }
}
