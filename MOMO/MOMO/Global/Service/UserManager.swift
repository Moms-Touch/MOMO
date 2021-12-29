//
//  UserManager.swift
//  MOMO
//
//  Created by abc on 2021/12/28.
//

import Foundation

final class UserManager {
  
  static let shared = UserManager()
  
  static let didSetAppUserNotification = NSNotification.Name("didSetAppUserNotification")
  
  private init() { }
  
  private var accessToken: String?
  private var id: Int = -1
  
  var token: String? {
    get {
      return accessToken
    }
    set {
      accessToken = newValue
    }
  }
  
  var userId: Int {
    get {
      return id
    }
    set {
      id = newValue
    }
  }
  
  var appUser: UserData? {
    didSet {
      NotificationCenter.default.post(name: UserManager.didSetAppUserNotification, object: nil)
    }
  }
  
  var userInfo: UserData? {
    get {
      return appUser
    }
    set {
      appUser = newValue
    }
  }
  
  func deleteUser() {
    appUser = nil
    KeyChainService.shared.deleteFromKeyChain(account: "accessToken")
  }
  
}
