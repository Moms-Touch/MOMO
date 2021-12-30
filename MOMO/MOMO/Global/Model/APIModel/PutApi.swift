//
//  PutApi.swift
//  MOMO
//
//  Created by abc on 2021/12/28.
//

import Foundation

enum PutApi {
  case putBaby(token: String, id: Int, name: String, birth: String?, imageUrl: String?)
  case putUser(token: String, email: String, nickname: String, isPregnant: Bool, hasChild: Bool, age: Int, location: String)
}

extension PutApi: APIable {
  var contentType: ContentType {
    return .jsonData
  }
  
  var requestType: RequestType {
    .put
  }
  
  var encodingType: EncodingType {
    return .JSONEncoding
  }
  
  var header: [String : String]? {
    switch self {
    case .putBaby(let token, _, _, _, _), .putUser(let token, _, _, _, _, _, _):
      return [ "Authorization" : "Bearer \(token)"]
    }
  }
  
  var url: String {
    switch self {
    case .putBaby:
      return makePathtoURL(path: "/baby")
    case .putUser:
      return makePathtoURL(path: "/member")
    }
  }
  
  var param: [String : String?]? {
    switch self {
    case .putBaby(_, let id, let name, let birth, let imageUrl) :
      return ["id": String(id), "name": name, "birth": birth, "imageUrl": imageUrl]
    case .putUser(_, let email,let nickname, let isPregnant, let hasChild, let age, let location):
      return ["email": email, "nickname": nickname, "isPregnant": String(isPregnant),
              "hasChild": String(isPregnant), "age": "\(age)", "location": location]
    }
  }
  
  func makePathtoURL(path: String?) -> String {
    return NetworkManager.baseUrl + "\(path ?? "")"
  }
}
