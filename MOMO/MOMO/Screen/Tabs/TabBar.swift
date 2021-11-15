//
//  Tabbar.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit

class TabBar: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    UITabBar.appearance().barTintColor = .white
    UITabBar.appearance().isTranslucent = false
    tabBar.tintColor = UIColor(named: "Pink1")
    setupVCs()
  }
  
  fileprivate func createNavController(for rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
    let navController = UINavigationController(rootViewController: rootViewController)
    navController.tabBarItem.image = image
    navController.tabBarItem.title = title
    navController.navigationBar.isHidden = true
    return navController
  }
  
  func setupVCs() {
    viewControllers = [
      createNavController(for: HomeMainViewController.loadFromStoryboard(), image: UIImage(named: "home")!, title: "홈"),
      createNavController(for: DiaryMainViewController(), image: UIImage(named: "calendar")!, title: "오늘 일기"),
      createNavController(for: PolicyMainViewController(), image: UIImage(named: "policy")!, title: "정책"),
      createNavController(for: MyInfoMainViewController.loadFromStoryboard(), image: UIImage(named: "people")!, title: "MY")
    ]
  }

}
