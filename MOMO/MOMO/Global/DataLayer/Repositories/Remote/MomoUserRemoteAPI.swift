//
//  MomoUserRemoteAPI.swift
//  MOMO
//
//  Created by abc on 2022/03/13.
//

import Foundation
import RxSwift

final class MomoUserRemoteAPI: UserRemoteAPI {
  
  func readUserSession() -> Observable<UserSession> {
    <#code#>
  }
  
  
  func deleteUser() -> Completable {
    <#code#>
  }
  
  func updateUserInfo(with info: UserData) -> Observable<UserData> {
    <#code#>
  }
  
  func updatePassword(from old: String, with new: String) -> Completable {
    <#code#>
  }
  
  

  
}
