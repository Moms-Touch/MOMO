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
      guard let babyBirth = userInfo?.baby?.first?.birthday else {return nil}
      return babyBirth.trimStringDate().fetusInWeek()
    } else { //출산 후
      guard let babyBirth = userInfo?.baby?.first?.birthday else {return nil}
      return babyBirth.trimStringDate().babyInWeek()
    }
  }
  
  func deleteUser() {
    appUser = nil
//    KeyChainService.shared.deleteFromKeyChain(account: "accessToken")
  }
  
  var periodOfWeek: (Int, Int)? {
    if userInfo?.isPregnant == true { //임신중
      guard let babyInWeek = babyInWeek else {
        return nil
      }
      switch Int(babyInWeek.components(separatedBy: "주차")[0])! {
      case 1...8:
        return (1, 8)
      case 9...16:
        return (9, 16)
      case 17...24:
        return (17, 24)
      case 25...32:
        return (25, 32)
      case 33...40:
        return (33, 40)
      default:
        return (1, 8)
      }
    }
    return (1, 8)
  }
  
}
