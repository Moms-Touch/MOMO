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
    if #available(iOS 15.0, *) {
      let appearance = UITabBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.backgroundColor = .white
      tabBar.standardAppearance = appearance
      tabBar.scrollEdgeAppearance = tabBar.standardAppearance
    }
    
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
      createNavController(for: DiaryMainViewController.loadFromStoryboard(), image: UIImage(named: "calendar")!, title: "오늘 일기"),
      createNavController(for: PolicyMainViewController(), image: UIImage(named: "policy")!, title: "정책"),
//      createNavController(for: CommunityMainViewController(), image: UIImage(named: "people")!, title: "커뮤니티")
    ]
  }
  
}
