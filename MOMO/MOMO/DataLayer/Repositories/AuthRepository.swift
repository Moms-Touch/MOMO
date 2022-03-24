//
//  AuthRepository.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation
import RxSwift

protocol AuthRepository {
  
  @discardableResult
  func signIn(email: String, password: String) -> Observable<Token>
  
  @discardableResult
  func readUserSession(token: String) -> Observable<UserSession>
  
  @discardableResult
  func authenticateToken(token: String) -> Observable<Token>
  
}
