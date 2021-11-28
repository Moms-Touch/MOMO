//
//  WithTextCollectionViewCell.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/27.
//

import UIKit

class WithTextCollectionViewCell: UICollectionViewCell, NibInstantiatable {
  
  static var identifier = String(describing: self)
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  @IBOutlet weak var questionLabel: UILabel!
  
  @IBOutlet weak var answerTextView: UITextView!
}
