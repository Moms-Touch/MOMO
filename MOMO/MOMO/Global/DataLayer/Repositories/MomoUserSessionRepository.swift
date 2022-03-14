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
    let userdata = PublishSubject<(UserData, Token)>()
    
    // 통신
    userSession
      .compactMap { $0 }
      .map { session -> (UserData, Token) in
        var profile = session.profile
        profile.nickname = new
        return (profile, session.token)
      }
      .subscribe(onNext: { [weak self] profile, token in
        guard let self = self else {return}
        self.userRemoteAPI.updateUserInfo(with: profile, token: token)
          .map{ return ($0, token)}
          .bind(to: userdata)
          .disposed(by: self.disposeBag)
      })
      .disposed(by: disposeBag)
    
    // datastorage에 저장하기
    userdata
      .subscribe(onNext: { [weak self] profile, token in
        guard let self = self else {return}
        let session =  UserSession(profile: profile, token: token)
        //데이터 저장
        self.userDataStore.save(userSession: session)
        //변경된 데이터 저장
//        self.userSession.onNext(session)
      })
      .disposed(by: disposeBag)
    
    return userdata
      .map { $0.0}
      .asObservable()
      .share()
  }
  
  @discardableResult
  func changeLocation(with new: String) -> Observable<UserData> {
    let userdata = PublishSubject<(UserData, Token)>()
    
    // 통신
    userSession
      .compactMap { $0 }
      .map { session -> (UserData, Token) in
        var profile = session.profile
        profile.location = new
        return (profile, session.token)
      }
      .subscribe(onNext: { [weak self] profile, token in
        guard let self = self else {return}
        self.userRemoteAPI.updateUserInfo(with: profile, token: token)
          .map{ return ($0, token)}
          .bind(to: userdata)
          .disposed(by: self.disposeBag)
      })
      .disposed(by: disposeBag)
    
    // datastorage에 저장하기
    userdata
      .subscribe(onNext: { [weak self] profile, token in
        guard let self = self else {return}
        let session =  UserSession(profile: profile, token: token)
        //데이터 저장
        self.userDataStore.save(userSession: session)
        //변경된 데이터 저장
//        self.userSession.onNext(session)
      })
      .disposed(by: disposeBag)
    
    return userdata
      .map { $0.0}
      .asObservable()
      .share()

    
  }
  
  @discardableResult
  func changePassword(from old: String, with new: String) -> Completable{
    print(#function)
    return Completable.empty()
  }
  
  @discardableResult
  func changeCurrentStatus(isPregnant: Bool) -> Observable<UserData> {
    let userdata = PublishSubject<(UserData, Token)>()
    
    // 통신
    userSession
      .compactMap { $0 }
      .map { session -> (UserData, Token) in
        var profile = session.profile
        profile.isPregnant = isPregnant
        return (profile, session.token)
      }
      .subscribe(onNext: { [weak self] profile, token in
        guard let self = self else {return}
        self.userRemoteAPI.updateUserInfo(with: profile, token: token)
          .map{ return ($0, token)}
          .bind(to: userdata)
          .disposed(by: self.disposeBag)
      })
      .disposed(by: disposeBag)
    
    // datastorage에 저장하기
    userdata
      .subscribe(onNext: { [weak self] profile, token in
        guard let self = self else {return}
        let session =  UserSession(profile: profile, token: token)
        //데이터 저장
        self.userDataStore.save(userSession: session)
        //변경된 데이터 저장
//        self.userSession.onNext(session)
      })
      .disposed(by: disposeBag)
    
    return userdata
      .map { $0.0}
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
      
      self.userSession
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

