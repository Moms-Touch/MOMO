//
//  MyBabyInfoViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/10.
//

import UIKit

class MyBabyInfoViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var myBabyImageView: UIImageView!
  @IBOutlet var myBabyInfoTextFields: [UITextField]! {
    didSet {
      for index in myBabyInfoTextFields.indices {
        let textfield = myBabyInfoTextFields[index]
        textfield.attributedPlaceholder = NSAttributedString(string: BabyEditTextfields.allCases[index].rawValue, attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.pink1, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
        textfield.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textfield.addLeftPadding(width: 20)
        textfield.layer.borderColor = Asset.Colors.pink4.color.cgColor
      }
    }
  }
  @IBOutlet weak var saveButton: UIButton! {
    didSet {
      saveButton.setRound(5)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
}

extension MyBabyInfoViewController {
  enum BabyEditTextfields: String, CaseIterable {
    case babyName = "아기이름"
    case birth = "출생일/출생예정일"
  }
}

extension MyBabyInfoViewController {}
