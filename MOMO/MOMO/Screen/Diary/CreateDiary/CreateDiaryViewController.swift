//
//  CreateDiaryViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/14.
//

import UIKit

struct DiaryCreationType {
  
  enum InputType {
    case text
    case voice
  }
  
  var inputType: InputType?
  var hasGuide: Bool?
}


class CreateDiaryViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var diaryInputView: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let vc = WithTextViewController.loadFromStoryboard()

    addChild(vc)
    
    diaryInputView.addSubview(vc.view)
    
    vc.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      vc.view.leadingAnchor.constraint(equalTo: diaryInputView.leadingAnchor),
      vc.view.topAnchor.constraint(equalTo: diaryInputView.topAnchor),
      vc.view.trailingAnchor.constraint(equalTo: diaryInputView.trailingAnchor),
      vc.view.bottomAnchor.constraint(equalTo: diaryInputView.bottomAnchor),
    ])
    
    vc.didMove(toParent: self)
  }
}
