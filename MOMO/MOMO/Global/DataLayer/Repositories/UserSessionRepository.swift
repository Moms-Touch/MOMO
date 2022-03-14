//
//  MyInfoRepository.swift
//  MOMO
//
//  Created by abc on 2022/03/12.
//

import Foundation
import RxSwift

protocol UserSessionRepository {
  
  @discardableResult
  func readUserSession() -> Observable<UserSession>
  
  @discardableResult
  func renameNickname(with new: String) -> Observable<UserData>
  
  @discardableResult
  func changeLocation(with new: String) -> Observable<UserData>
  
  @discardableResult
  func changePassword(from old: String, with new: String) ->  Completable
  
  @discardableResult
  func changeCurrentStatus(with new: String) -> Observable<UserData>
  
  @discardableResult
  func deleteUser() -> Completable
}
