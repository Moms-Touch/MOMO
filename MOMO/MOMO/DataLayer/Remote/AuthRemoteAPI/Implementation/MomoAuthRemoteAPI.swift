//
//  MomoAuthRemoteAPI.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation
import RxSwift
/**
 MomoAuthRemoteAPI Auth 관련 중에, 네트워킹이 필요한 작업이 들어있는 API이다.
 */
final class MomoAuthRemoteAPI: AuthRemoteAPI {
  
  //MARK: - Private Properties
  private let decoder: NetworkDecoding
  private let networkManager: NetworkProtocol
  private var token: Token = ""
  
  
  public init(networkManager: NetworkProtocol, decoder: NetworkDecoding) {
    self.networkManager = networkManager
    self.decoder = decoder
  }
  
    /**
     토큰을 활용해 현재 유저의 정보를 받아와서 Observable로 넘겨준다.
     - Parameter token: Token
     - Returns: Observable<UserSession>
     */
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
    
  /**
   email, password를 받아서 로그인을 하는 API로 Observable<token>을 return 한다.
   - Parameter email: 사용자가 입력한 email
   - Parameter password: 사용자가 입력한 password
   - Returns: 토큰 옵저버블
   */
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
  
    /**
     userdefault or Keychain 에서 받아온 Token을 활용해서 자동로그인할때 사용되는 API
     - Parameter token: userdefault or Keychain 에서 받아온 Token
     - Returns: 로그인 실패시: 'Observable.error(CodingError.decodingError)' / 로그인 성공시: Observable<LoginData>
     */
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
