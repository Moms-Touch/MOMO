//
//  UserRemoteAPI.swift
//  MOMO
//
//  Created by abc on 2022/03/12.
//

import Foundation
import RxSwift

protocol UserRemoteAPI {
  
  @discardableResult
  func readUserSession() -> Observable<UserSession>
  
  @discardableResult
  func deleteUser() -> Completable
  
  @discardableResult
  func updateUserInfo(with info: UserData) -> Observable<UserData>
  
  @discardableResult
  func updatePassword(from old: String, with new: String) -> Completable
}
