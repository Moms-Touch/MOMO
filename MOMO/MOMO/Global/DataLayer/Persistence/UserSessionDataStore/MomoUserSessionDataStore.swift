//
//  MomoUserSessionDataStore.swift
//  MOMO
//
//  Created by abc on 2022/03/15.
//

import Foundation
import RxSwift

enum DatastoreConstant {
  static var tokenKey: String {
    return "accessToken"
  }
}

final class MomoUserSessionDataStore: UserSessionDataStore {
  
  private let userManager: UserManager
  private let keychainService: KeyChainService
  
  init(userManager: UserManager, keychainService: KeyChainService) {
    self.userManager = userManager
    self.keychainService = keychainService
  }
  
  func readUserSession() -> Observable<UserSession?> {
    
    let userDataObservable = readUserData()
    let tokenObservable = readToken()
    
    let combinedObservable = Observable.zip(userDataObservable, tokenObservable)
      .map { profile, token -> UserSession? in
        guard let profile = profile, let token = token else {
          return nil
        }
        return UserSession(profile: profile, token: token)
      }
      .share()
    
    return combinedObservable
  }
  
  func readUserData() -> Observable<UserData?> {
    Observable .just(userManager.userInfo)
      .share()
  }
  
  func readToken() -> Observable<Token?> {
    Observable.just(keychainService.loadFromKeychain(account: DatastoreConstant.tokenKey))
      .share()
  }
  
  func save(userSession: UserSession) -> Observable<UserSession> {
    let token = userSession.token
    let profile = userSession.profile
    
    //Token 저장
    if let _ = keychainService.loadFromKeychain(account: DatastoreConstant.tokenKey) {
      keychainService.deleteFromKeyChain(account: DatastoreConstant.tokenKey)
      keychainService.saveInKeychain(account: DatastoreConstant.tokenKey, value: token)
    } else {
      keychainService.saveInKeychain(account: DatastoreConstant.tokenKey, value: token)
    }
    
    //Userdata 저장
    userManager.userInfo = profile
    
    return Observable.just(userSession)
      .share()
  }
  
  func delete(userSession: UserSession) -> Completable {
    
    return Completable.create { [weak self] completable in
      
      guard let self = self else {return completable(.error(AppError.noSelf)) as! Disposable}
    
      let token = userSession.token
      
      guard let accessToken = self.keychainService.loadFromKeychain(account: DatastoreConstant.tokenKey), accessToken == token else {
        return completable(.error(KeyChainError.noValue)) as! Disposable
      }
      
      self.keychainService.deleteFromKeyChain(account: DatastoreConstant.tokenKey)
      self.userManager.deleteUser()
      completable(.completed)
      return Disposables.create {}
    }
     
  }
}
