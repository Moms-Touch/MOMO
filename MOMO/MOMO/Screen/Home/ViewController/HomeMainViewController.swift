//
//  HomeMainViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit
import PanModal

class HomeMainViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var noticeView: UIView! {
    didSet {
      noticeView.backgroundColor = UIColor(rgb: 0x000000).withAlphaComponent(0.1)
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    assignbackground()
  }
  
  func assignbackground(){
         let background = UIImage(named: "mainBackground")

         var imageView : UIImageView!
         imageView = UIImageView(frame: view.bounds)
         imageView.contentMode =  UIView.ContentMode.scaleAspectFill
         imageView.clipsToBounds = true
         imageView.image = background
         imageView.center = view.center
         view.addSubview(imageView)
         self.view.sendSubviewToBack(imageView)
     }
  
  @IBAction func didTapRecommendButton(_ sender: UIButton) {
    presentPanModal(RecommendModalViewController())
  }
  @IBAction func didTapTodayButton(_ sender: UIButton) {
    print(#function)
  }
  
}


