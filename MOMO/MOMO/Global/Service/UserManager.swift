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
  
  private var appUser: UserData? {
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
  
  var babyInWeek: String? {
    if userInfo?.isPregnant == true { // 임신 중
      guard let babyBirth = userInfo?.baby?.first?.birth else {return nil}
      return babyBirth.trimStringDate().fetusInWeek()
    } else { //출산 후
      guard let babyBirth = userInfo?.baby?.first?.birth else {return nil}
      return babyBirth.trimStringDate().babyInWeek()
    }
  }
  
  func deleteUser() {
    appUser = nil
    KeyChainService.shared.deleteFromKeyChain(account: "accessToken")
  }
  
}
