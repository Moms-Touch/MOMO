//
//  SceneDelegate.swift
//  MOMO
//
//  Created by Woochan Park on 2021/10/04.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var isLogged = true
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    
//    // keychain에 토큰 유무 확인
//    if let accessToken = KeyChainService.shared.loadFromKeychain(account: "accessToken") {
//      // TODO: 토큰검증
//      if true { // TODO: res로 토큰을 받았다면
//        // TODO: keychain에서 삭제 후 저장 실시(삭제 무조건 실시해야함)
//        KeyChainService.shared.deleteFromKeyChain(account: "accessToken") //지우고
//        KeyChainService.shared.saveInKeychain(account: "accessToken", value: accessToken)
//        //TODO: userId와 토큰값을 저장
//        //TODO: user가져오기를 통해서 Userdata에 추가
//        let home = TabBar()
//        home.selectedIndex = 0
//        self.window?.rootViewController = home
//      }
//    } else {
//      isLogged = false
//      window?.rootViewController = UINavigationController(rootViewController: LoginViewController.loadFromStoryboard())
//    }
    
    if !isLogged {
      window?.rootViewController = UINavigationController(rootViewController: LoginViewController.loadFromStoryboard())
    } else {
      let home = TabBar()
      home.selectedIndex = 0
      self.window?.rootViewController = home
    }
//    window?.rootViewController = CreateQuestionViewController.loadFromStoryboard()
//    window?.rootViewController = CreateDiaryViewController.loadFromStoryboard()
//    window?.rootViewController = WithTextViewController.loadFromStoryboard()
    
//    window?.rootViewController = DiaryInputOptionViewController.loadFromStoryboard()
    window?.windowScene = windowScene
    self.window?.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) {
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }


}

