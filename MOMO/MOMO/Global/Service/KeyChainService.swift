//
//  KeyChainService.swift
//  MOMO
//
//  Created by abc on 2021/12/15.
//

import Foundation

class KeyChainService {
  
  static let shared = KeyChainService()
  private let bundleName = "net.momstouch.MOMO"
  
  private init() { }
  
  func saveInKeychain(account: String, value: String) {
    // 키체인쿼리
    let keyChainQuery: NSDictionary = [
      kSecClass: kSecClassGenericPassword, //아이탬 클레스
      kSecAttrService: bundleName, //앱 번들 아이디
      kSecAttrAccount: account, //사용자 계정
      kSecValueData: value.data(using: .utf8, allowLossyConversion: false)! //저장할 값
    ]
    
    // 값 삭제
    SecItemDelete(keyChainQuery)
    
    // 새로운 키체인 아이템 등록
    let status: OSStatus = SecItemAdd(keyChainQuery, nil)
    assert(status == noErr, "토큰 값 저장에 실패")
    NSLog("status=\(status)")
  }
  
  func loadFromKeychain(account: String) -> String? {
    let keyChainQuery: NSDictionary = [
      kSecClass: kSecClassGenericPassword, //아이탬 클레스
      kSecAttrService: bundleName, //앱 번들 아이디
      kSecAttrAccount: account, //사용자 계정
      kSecReturnData: kCFBooleanTrue, // CFData으로 불러오라
      kSecMatchLimit: kSecMatchLimitOne // 중복되는 경우 한개만
    ]
    
    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
    
    if status == errSecSuccess {
      let retrievedData = dataTypeRef as! Data
      let value = String(data: retrievedData, encoding: String.Encoding.utf8)
      return value
    } else {
      print("토큰 로드 실패, status = \(status)")
      return nil
    }
  }
  
  func deleteFromKeyChain(account: String) {
    let keyChainQuery: NSDictionary = [
      kSecClass: kSecClassGenericPassword, //아이탬 클레스
      kSecAttrService: bundleName, //앱 번들 아이디
      kSecAttrAccount: account, //사용자 계정
    ]
    
    let status = SecItemDelete(keyChainQuery)
    assert(status == noErr, "토큰 값 삭제에 실패했습니다")
    NSLog("status=\(status)")
  }
  
}
