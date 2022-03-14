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
  func deleteUser(token: Token) -> Completable
  
  @discardableResult
  func updateUserInfo(with info: UserData, token: Token) -> Observable<UserData>
  
  @discardableResult
  func updatePassword(from old: String, with new: String, token: Token) -> Completable
}
