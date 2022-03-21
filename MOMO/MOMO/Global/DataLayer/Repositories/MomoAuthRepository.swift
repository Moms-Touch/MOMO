//
//  MomoAuthRepository.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation
import RxSwift

final class MomoAuthRepository: AuthRepository {
  
  private var tokenSubject = BehaviorSubject<Token>(value: "")
  private var userDataStorage: UserSessionDataStore
  private var remoteAPI: AuthRemoteAPI
  private var disposeBag = DisposeBag()
  
  public init(remoteAPI: AuthRemoteAPI, userDataStorage: UserSessionDataStore) {
    self.remoteAPI = remoteAPI
    self.userDataStorage = userDataStorage
  }
  
  func signIn(email: String, password: String) -> Observable<Token> {
    
    remoteAPI.signIn(email: email, password: password)
      .bind(to: tokenSubject)
      .disposed(by: disposeBag)
    
    // 저장
    tokenSubject
      .subscribe(onNext: { [weak self] token in
        guard let self = self else { return }
        self.readUserSession(token: token)
          .subscribe(onNext: {
            self.userDataStorage.save(userSession: $0)
          })
          .disposed(by: self.disposeBag)
      })
      .disposed(by: disposeBag)
    
    return tokenSubject.asObservable().share()
  }
  
  func readUserSession(token: String) -> Observable<UserSession> {
    return remoteAPI.readUserSession(token: token).share()
  }
  
  func authenticateToken(token: String) -> Observable<Token> {
    
    remoteAPI.authenticateToken(token: token)
      .map { $0.accesstoken }
      .bind(to: tokenSubject)
      .disposed(by: disposeBag)
    
    // 저장
    tokenSubject
      .subscribe(onNext: { [weak self] token in
        guard let self = self else { return }
        self.readUserSession(token: token)
          .subscribe(onNext: {
            self.userDataStorage.save(userSession: $0)
          })
          .disposed(by: self.disposeBag)
      })
      .disposed(by: disposeBag)
    
    return tokenSubject.asObservable().share()
  }
  
}
