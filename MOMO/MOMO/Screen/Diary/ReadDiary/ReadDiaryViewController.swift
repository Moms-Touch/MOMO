//
//  ReadDiaryViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/12/31.
//

import UIKit

class ReadDiaryViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var firstQuestionLabel: UILabel!
  
  @IBOutlet weak var secondQuestionLabel: UILabel!
  
  @IBOutlet weak var thirdQuestionLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func dismiss(_ sender: UIButton) {
    
    self.navigationController?.popViewController(animated: true)
  }
  
}
