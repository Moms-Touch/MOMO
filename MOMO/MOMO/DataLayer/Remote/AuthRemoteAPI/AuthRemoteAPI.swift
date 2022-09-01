//
//  AuthRemoteAPI.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation
import RxSwift

protocol AuthRemoteAPI {
  
  @discardableResult
  func signIn(email: String, password: String) -> Observable<Token>
  
  @discardableResult
  func authenticateToken(token: Token) -> Observable<LoginData>
  
  @discardableResult
  func readUserSession(token: Token) -> Observable<UserSession>
}
