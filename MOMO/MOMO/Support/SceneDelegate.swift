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
    
    if let accessToken = KeyChainService.shared.loadFromKeychain(account: "accessToken") {
      
      // 토큰 검증
      let networkManager = NetworkManager()
      
      networkManager.request(apiModel: GetApi.loginGet(token: accessToken)) { [weak self] (result) in
        guard let self = self else { return }
        switch result {
        case .success(let data):
          let parsingManager = ParsingManager()
          parsingManager.judgeGenericResponse(data: data, model: LoginData.self) { (body) in
            
            let newAccessToken = body.accesstoken
            let userId = body.id
          
            KeyChainService.shared.deleteFromKeyChain(account: "accessToken") //지우고
            
            //keychain에서 삭제 후 저장 실시(삭제 무조건 실시해야함)
            KeyChainService.shared.saveInKeychain(account: "accessToken", value: newAccessToken)
            
            //TODO: userId와 토큰값을 저장
            UserManager.shared.token = newAccessToken
            UserManager.shared.userId = userId
            
            //TODO: user가져오기를 통해서 Userdata에 추가
            
            
            DispatchQueue.main.async {
              let home = TabBar()
              home.selectedIndex = 0
              self.window?.rootViewController = home
            }
          }
        case .failure(_):
         // 토큰이 만료되었다 -> 로그인으로 보낸다
          self.isLogged = false
          DispatchQueue.main.async {
            self.window?.rootViewController = UINavigationController(rootViewController: LoginViewController.loadFromStoryboard())
            self.window?.windowScene = windowScene
            self.window?.makeKeyAndVisible()
          }
        }
      }
    } else {
      // REAL CODE
//      isLogged = false
//      window?.rootViewController = UINavigationController(rootViewController: LoginViewController.loadFromStoryboard())
//      window?.windowScene = windowScene
//      self.window?.makeKeyAndVisible()
      
      //TESTCODE
      let networkManager = NetworkManager()
      
      networkManager.request(apiModel: GetApi.loginGet(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzgsImVtYWlsIjoiZG9oeXVuQG5hdmVyLmNvbSIsIm5hbWUiOiJkb2h5dW4iLCJpYXQiOjE2NDA2NjM5ODAsImV4cCI6MTY0MDkyMzE4MCwiaXNzIjoibW9tbyJ9.AbP-nogLjH68pAWhJrNzFT4M_kOCkrbMTFb4h_zoMkk")) {(result) in
        switch result {
        case .success(let data):
          let parsingManager = ParsingManager()
          parsingManager.judgeGenericResponse(data: data, model: LoginData.self) { [weak self] (body) in
            guard let self = self else { return }
            //TODO: userId와 토큰값을 저장
            UserManager.shared.token = body.accesstoken
            UserManager.shared.userId = body.id
            
            //TODO: user가져오기를 통해서 Userdata에 추가
            
            DispatchQueue.main.async {
              let home = TabBar()
              home.selectedIndex = 0
              self.window?.rootViewController = home
              self.window?.windowScene = windowScene
              self.window?.makeKeyAndVisible()
            }
          }
        case .failure(let error):
         // 토큰이 만료되었다 -> 로그인으로 보낸다
          print(error)
          self.isLogged = false
          DispatchQueue.main.async {
//            self.window?.rootViewController = UINavigationController(rootViewController: LoginViewController.loadFromStoryboard())
            let home = TabBar()
            home.selectedIndex = 0
            self.window?.rootViewController = home
            self.window?.windowScene = windowScene
            self.window?.makeKeyAndVisible()
          }
        }
      }
      
    }
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

