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
      appearance.backgroundColor = .white.withAlphaComponent(0.8)
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
  
  let networkManager = NetworkManager()
  let decoder = NetworkCoder()
  let datastore = MomoUserSessionDataStore(userManager: UserManager.shared, keychainService: KeyChainService.shared)
  
  private func makeRecommendViewController() -> UIViewController {
    let userRemoteAPI = MomoUserRemoteAPI(networkManager: networkManager, decoder: decoder)
    let userRepository = MomoUserSessionRepository(remoteAPI: userRemoteAPI, dataStore: datastore)
    let remoteAPI = MomoRecommendRemoteAPI(networkManager: networkManager, decoder: decoder)
    let repository = MomoRecommendRepository(remoteAPI: remoteAPI, userSessionDataStore: datastore)
    let viewmodel = RecommendViewModel(reposoitory: repository, userRepository: userRepository)
    return RecommendViewController(viewModel: viewmodel)
  }
  
  private func makeHomeViewController() -> UIViewController {
    let userRemoteAPI = MomoUserRemoteAPI(networkManager: networkManager, decoder: decoder)
    let userRepository = MomoUserSessionRepository(remoteAPI: userRemoteAPI, dataStore: datastore)
    let datastore = MomoDiaryDataStore()
    let repository = MomoDiaryRepository(diaryDataStore: datastore)
    let diaryUsecase = MomoDiaryUseCase(repository: repository)
    let viewmodel = HomeMainViewModel(diaryUseCase: diaryUsecase, userRepository: userRepository)
    return HomeMainViewController(viewModel: viewmodel)
  }
  
  func setupVCs() {
    viewControllers = [
      createNavController(for: makeHomeViewController(), image: UIImage(named: "home")!, title: "홈"),
      createNavController(for: makeRecommendViewController(), image: UIImage(systemName: "lightbulb")!, title: "추천 정보"),
      createNavController(for: PolicyMainViewController.loadFromStoryboard(), image: UIImage(named: "policy")!, title: "정책"),
//      createNavController(for: CommunityMainViewController(), image: UIImage(named: "people")!, title: "커뮤니티")
    ]
  }
  
}
