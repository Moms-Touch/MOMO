//
//  CreateQuestionViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/28.
//

import UIKit

class CreateQuestionViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var postButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpPostButton()
  }
    
  private func setUpPostButton() {
    
    postButton.layer.cornerRadius = 5
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
