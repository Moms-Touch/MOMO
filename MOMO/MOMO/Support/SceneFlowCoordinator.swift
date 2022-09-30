//
//  SceneFlowCoordinator.swift
//  MOMO
//
//  Created by Woochan Park on 2022/09/30.
//

import UIKit

final class SceneFlowCoordinator {
    
    var navigationController: UINavigationController
    
    private let sceneDIContainer: SceneDIContainer
    
    init(navigationController: UINavigationController, sceneDIContainer: SceneDIContainer) {
        self.navigationController = navigationController
        self.sceneDIContainer = sceneDIContainer
    }
    
    func start() {
        
        let loginDIContainer = sceneDIContainer.makeLoginDIContainer()
        
//        LoginFlowCoordinator()
        
        
        // TODO: 자동로그인
        
        // 자동 로그인 여부 확인
//        if sceneDICOntainer.LoginModule.checkAutoLoginAvailable() {
            
//            HomeFlowCoordinator()
            
//        } else {
            
            //TODO: LoginFlow
            
//            LoginFlowCoordinator()
//        }
        
    }
}
