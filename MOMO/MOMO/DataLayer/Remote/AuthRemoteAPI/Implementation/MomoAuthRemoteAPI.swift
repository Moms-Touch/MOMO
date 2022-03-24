//
//  MomoAuthRemoteAPI.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation
import RxSwift

final class MomoAuthRemoteAPI: AuthRemoteAPI {
  
  //MARK: - Private Properties
  private let decoder: NetworkDecoding
  private let networkManager: NetworkProtocol
  private var token: Token = ""
  
  
  public init(networkManager: NetworkProtocol, decoder: NetworkDecoding) {
    self.networkManager = networkManager
    self.decoder = decoder
  }
  
  func readUserSession(token: Token) -> Observable<UserSession> {

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
  
  func signIn(email: String, password: String) -> Observable<Token> {
    return networkManager.request(apiModel: PostApi.login(email: email, password: password, contentType: .jsonData))
      .asObservable()
      .flatMap { [weak self] data -> Observable<Token> in
        guard let self = self else { return Observable.error(CodingError.decodingError)}
        let loginObservable = self.decoder.decode(data: data, model: LoginData.self)
        return loginObservable
          .map {
            let token = $0.accesstoken
            self.token = token
            return token
          }
      }
  }
  
  func authenticateToken(token: Token) -> Observable<LoginData> {
    return networkManager.request(apiModel: GetApi.loginGet(token: token))
      .asObservable()
      .flatMap { [weak self] data -> Observable<LoginData> in
        guard let self = self else {
          return Observable.error(CodingError.decodingError)
        }
        let authTokenObservable = self.decoder.decode(data: data, model: LoginData.self)
        return authTokenObservable
      }
  }
}
