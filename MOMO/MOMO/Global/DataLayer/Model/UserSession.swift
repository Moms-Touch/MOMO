//
//  UserSession.swift
//  MOMO
//
//  Created by abc on 2022/03/12.
//

import Foundation

class UserSession {
  
  //MARK: - Properties
  let profile: UserData
  let token: Token
  
  public init(profile: UserData, token: Token) {
    self.profile = profile
    self.token = token
  }
  
}

extension UserSession: Equatable {
  static func == (lhs: UserSession, rhs: UserSession) -> Bool {
    return lhs.profile == rhs.profile && lhs.token == rhs.token
  }
}
