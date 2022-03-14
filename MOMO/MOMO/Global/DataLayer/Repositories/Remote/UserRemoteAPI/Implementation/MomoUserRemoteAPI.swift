//
//  MomoUserRemoteAPI.swift
//  MOMO
//
//  Created by abc on 2022/03/13.
//

import Foundation
import RxSwift

final class MomoUserRemoteAPI: UserRemoteAPI {
  
  //MARK: - Private Properties
  private let networkManager: NetworkProtocol
  private let decoder: NetworkDecoding
  private let userSession: UserSession
  
  //MARK: - init
  public init(networkManager: NetworkProtocol, decoder: NetworkDecoding, userSession: UserSession) {
    self.networkManager = networkManager
    self.decoder = decoder
    self.userSession = userSession
  }
  
  //MARK: - Methods
  
  func readUserSession() -> Observable<UserSession> {
    let token = userSession.token
    return networkManager.request(apiModel: GetApi.userGet(token: token))
      .asObservable()
      .flatMap { [weak self] data -> Observable<UserSession> in
        guard let self = self else { return Observable.error(CodingError.decodingError)}
        
        let observable = self.decoder.decode(data: data, model: UserData.self)
          .map {
            return UserSession(profile: $0, token: token)
          }
        
        return observable
      }
  }
  
  func deleteUser() -> Completable {
    let token = userSession.token
    return networkManager.request(apiModel: DeleteApi.deleteUser(token: token))
      .asCompletable()
  }
  
  func updateUserInfo(with info: UserData) -> Observable<UserData> {
    let token = userSession.token
    return networkManager.request(apiModel: PutApi.putUser(token: token, email: info.email , nickname: info.nickname, isPregnant: info.isPregnant, hasChild: info.hasChild, age: info.age, location: info.location))
      .asObservable()
      .flatMap { [weak self] data -> Observable<UserData> in
        guard let self = self else {return Observable.error(CodingError.decodingError)}
        return self.decoder.decode(data: data, model: UserData.self)
      }
  }
  
  // cloud API not yet
  @available(*, deprecated)
  func updatePassword(from old: String, with new: String) -> Completable {
    return Completable.create { complete in
      complete(.completed) as! Disposable
    }
  }

}
