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
  
  init(remoteAPI: UserRemoteAPI, dataStore: UserSessionDataStore) {
    self.userDataStore = dataStore
    self.userRemoteAPI = remoteAPI
  }
  
  @discardableResult
  func readUserSession() -> Observable<UserSession> {
    
    let observable = self.userDataStore.readUserSession()
      .compactMap { $0 }
      .share()
    
    return observable
  }
  
  
  @discardableResult
  func renameNickname(with new: String) -> Observable<UserData> {
    
    return readUserSession()
      .compactMap { $0 }
      .map { session -> (UserData, Token) in
        var profile = session.profile
        profile.nickname = new
        return (profile, session.token)
      }
      .flatMap({ (profile, token) -> Observable<(UserData, Token)> in
        let left = self.userRemoteAPI.updateUserInfo(with: profile, token: token)
        let right = Observable.just(token)
        return Observable.zip(left, right)
      })
      .flatMap({ profile, token in
        return self.userDataStore.save(userSession: UserSession(profile: profile, token: token))
      })
      .map({ session in
        return (session.profile, session.token)
      })
      .compactMap { $0.0}
      .asObservable()
      .share()
      
  }
  
  @discardableResult
  func changeLocation(with new: String) -> Observable<UserData> {
    
    return readUserSession()
      .compactMap { $0 }
      .map { session -> (UserData, Token) in
        var profile = session.profile
        profile.location = new
        return (profile, session.token)
      }
      .flatMap({ (profile, token) -> Observable<(UserData, Token)> in
        let left = self.userRemoteAPI.updateUserInfo(with: profile, token: token)
        let right = Observable.just(token)
        return Observable.zip(left, right)
      })
      .flatMap({ profile, token in
        return self.userDataStore.save(userSession: UserSession(profile: profile, token: token))
      })
      .flatMap { session -> Observable<UserData> in
          return Observable.create { observer in
              observer.onNext(session.profile)
              return Disposables.create()
          }
      }
      .share()

  }
  
  @discardableResult
  func changePassword(from old: String, with new: String) -> Completable{
    print(#function)
    return Completable.empty()
  }
  
  @discardableResult
  func changeCurrentStatus(isPregnant: Bool) -> Observable<UserData> {
    
    return readUserSession()
      .compactMap { $0 }
      .map { session -> (UserData, Token) in
        var profile = session.profile
        profile.isPregnant = isPregnant
        return (profile, session.token)
      }
      .flatMap({ (profile, token) -> Observable<(UserData, Token)> in
        let left = self.userRemoteAPI.updateUserInfo(with: profile, token: token)
        let right = Observable.just(token)
        return Observable.zip(left, right)
      })
      .flatMap({ profile, token in
        return self.userDataStore.save(userSession: UserSession(profile: profile, token: token))
      })
      .map({ session in
        return (session.profile, session.token)
      })
      .compactMap { $0.0}
      .asObservable()
      .share()

  }
  
  //TODO: 이게 되는 코드인지 확인 필요
  @discardableResult
  func deleteUser() -> Completable {
    return Completable.create { [weak self] completable in
      
      guard let self = self else {
        completable(.error(AppError.invalidToken))
        return Disposables.create()
      }
      
      self.readUserSession()
        .compactMap { $0}
        .subscribe(onNext: {
          self.userRemoteAPI.deleteUser(token: $0.token)
            .subscribe(onCompleted: {
              completable(.completed)
            })
            .disposed(by: self.disposeBag)
          self.userDataStore.delete(userSession: $0)
            .subscribe(onCompleted: {
              completable(.completed)
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: self.disposeBag)
      
      return Disposables.create()
    }
  }
  
}

