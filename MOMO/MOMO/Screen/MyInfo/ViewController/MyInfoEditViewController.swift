//
//  MyInfoEditViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/10.
//

import UIKit

class MyInfoEditViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var myProfileImageView: UIImageView!
  
  @IBOutlet weak var saveButton: UIButton! {
    didSet {
      saveButton.setRound(5)
    }
  }
  @IBOutlet weak var infoEditScrollView: UIScrollView!
  
  @IBOutlet var myInfoTextFields: [UITextField]! {
    didSet {
      for index in myInfoTextFields.indices {
        let textfield = myInfoTextFields[index]
        textfield.attributedPlaceholder = NSAttributedString(string: EditTextfields.allCases[index].rawValue, attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.pink4.color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
        textfield.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textfield.addLeftPadding(width: 20)
        textfield.layer.borderColor = Asset.Colors.pink4.color.cgColor
      }
    }
  }
  
  @IBOutlet weak var distFromSaveButton: NSLayoutConstraint!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    myProfileImageView.setRound()
    scrollingKeyboard()
  }
  
  @IBAction func didTapSaveButton(_ sender: UIButton) {
    
  }
  
}

extension MyInfoEditViewController {
  enum EditTextfields: String, CaseIterable {
    case nick = "닉네임"
    case email = "이메일 계정"
    case cellPhone = "핸드폰 번호"
  }
  
  
}

extension MyInfoEditViewController: KeyboardScrollable {
  
  var scrollView: UIScrollView {
    return infoEditScrollView
  }
  
}

