//
//  UserDataStore.swift
//  MOMO
//
//  Created by abc on 2022/03/12.
//

import Foundation
import RxSwift

public typealias Token = String

protocol UserSessionDataStore {
  
  @discardableResult
  func readUserSession() -> Observable<UserSession?>
  
  @discardableResult
  func save(userSession: UserSession) -> Observable<UserSession>
  
  @discardableResult
  func delete(userSession: UserSession) -> Observable<UserSession>
}

