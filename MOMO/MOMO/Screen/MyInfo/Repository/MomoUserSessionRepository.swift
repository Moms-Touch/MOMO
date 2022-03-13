//
//  MyInfoRepositroy.swift
//  MOMO
//
//  Created by abc on 2022/03/12.
//

import Foundation
import RxSwift

final class MomoUserSessionRepository: UserSessionRepository {
  
  var userRemoteAPI: UserRemoteAPI
  var userDataStore: UserSessionDataStore
  
  init(remoteAPI: UserRemoteAPI, dataStore: UserSessionDataStore) {
    self.userDataStore = dataStore
    self.userRemoteAPI = remoteAPI
  }
  
  @discardableResult
  func readUserSession() -> Observable<UserSession?> {
    return Observable.empty()
      .share()
    //만약에 userstorage에 비었다면?
    //fetch해온다.
  }
  
  @discardableResult
  func renameNickname(with new: String) -> Observable<String> {
    print(#function)
    return Observable<String>.just("nickname")
      .share()
  }
  
  @discardableResult
  func changeLocation(with new: String) -> Observable<UserData> {
    print(#function)
    return Observable.empty()
      .share()
  }
  
  @discardableResult
  func changePassword(from old: String, with new: String) -> Completable{
    print(#function)
    return Completable.empty()
  }
  
  @discardableResult
  func changeCurrentStatus(with new: String) -> Observable<UserData> {
    print(#function)
    return Observable.empty()
      .share()
  }
  
  @discardableResult
  func deleteUser() -> Completable {
    print(#function)
    return Completable.empty()
  }
  
}

