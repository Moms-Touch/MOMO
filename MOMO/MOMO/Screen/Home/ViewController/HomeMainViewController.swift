//
//  HomeMainViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit
import PanModal

final class HomeMainViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var noticeView: UIView! {
    didSet {
      noticeView.backgroundColor = .black.withAlphaComponent(0.1)
    }
  }
  
  @IBOutlet weak var imageHuggingView: UIView! {
    didSet {
      imageHuggingView.setRound()
    }
  }
  @IBOutlet weak var babyProfileImageView: UIImageView! {
    didSet {
      babyProfileImageView.setRound()
      babyProfileImageView.isUserInteractionEnabled = true
      let tapgesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gotoMyProfile(_:)))
      babyProfileImageView.addGestureRecognizer(tapgesture)
      //Usermodel을 observing 하고 있어야함
    }
  }
  @IBOutlet weak var dateWithBabyButton: UIButton! {
    didSet {
      dateWithBabyButton.setRound()
      dateWithBabyButton.backgroundColor = .white
      //Usermodel을 observing 하고 있어야함
    }
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    assignbackground()
  }
  
  private func assignbackground(){
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
  
  @IBAction private func didTapRecommendButton(_ sender: UIButton) {
    presentPanModal(RecommendModalViewController())
  }
  
  @IBAction private func didTapTodayButton(_ sender: UIButton) {
    print(#function)
  }
  
  @IBAction private func didTapBookmarkListButton(_ sender: UIButton) {
    self.navigationController?.pushViewController(BookmarkListViewController.loadFromStoryboard(), animated: true)
  }
  
  @IBAction private func didTapProfile(_ sender: Any) {
    gotoMyProfile()
  }
  
  @objc private func gotoMyProfile(_ sender: Any?) {
    gotoMyProfile()
  }
  
  private func gotoMyProfile() {
    self.navigationController?.pushViewController(MyInfoMainViewController.loadFromStoryboard(), animated: true)
  }
  
  
  
}


