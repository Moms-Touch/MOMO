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
  /**
   UserSession 내부에 Userdata, token을 저장하면서, 후에 token, userdata가 필요할때 꺼내 쓸수있다.
   */
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
