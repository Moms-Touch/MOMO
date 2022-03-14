//
//  MyInfoRepositroy.swift
//  MOMO
//
//  Created by abc on 2022/03/12.
//

import Foundation
import RxSwift

final class MomoUserSessionRepository: UserSessionRepository {
  
  private var userRemoteAPI: UserRemoteAPI
  private var userDataStore: UserSessionDataStore
  private var disposeBag = DisposeBag()
  private var userSession: BehaviorSubject<UserSession?>
  
  init(remoteAPI: UserRemoteAPI, dataStore: UserSessionDataStore) {
    self.userDataStore = dataStore
    self.userRemoteAPI = remoteAPI
    self.userSession = BehaviorSubject<UserSession?>(value: nil)
    self.readUserSession()
      .bind(to: self.userSession)
      .disposed(by: disposeBag)
  }
  
  @discardableResult
  func readUserSession() -> Observable<UserSession> {
    self.userDataStore.readUserSession()
      .compactMap { $0 }
      .share()
  }
  
  @discardableResult
  func renameNickname(with new: String) -> Observable<UserData> {
    let userdata = PublishSubject<UserData>()
    
    // 통신
    userSession
      .compactMap { $0 }
      .map { session -> UserData in
        var profile = session.profile
        profile.nickname = new
        return profile
      }
      .subscribe(onNext: { [weak self] profile in
        guard let self = self else {return}
        self.userRemoteAPI.updateUserInfo(with: profile)
          .bind(to: userdata)
          .disposed(by: self.disposeBag)
      })
      .disposed(by: disposeBag)
    
    // datastorage에 저장하기

    self.userDataStore.save(userSession: )
    
    return userdata.asObservable()
      .share()
  }
  
  @discardableResult
  func changeLocation(with new: String) -> Observable<UserData> {
    
    
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

