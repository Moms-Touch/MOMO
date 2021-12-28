//
//  PutApi.swift
//  MOMO
//
//  Created by abc on 2021/12/28.
//

import Foundation

enum PutApi {
  case putBaby(token: String, id: Int, name: String, birth: String?, imageUrl: String?)
}

extension PutApi: APIable {
  var contentType: ContentType {
    return .jsonData
  }
  
  var requestType: RequestType {
    .patch
  }
  
  var encodingType: EncodingType {
    return .JSONEncoding
  }
  
  var header: [String : String]? {
    switch self {
    case .putBaby(let token, _, _, _, _):
      return [ "Authorization" : "Bearer \(token)"]
    }
  }
  
  var url: String {
    switch self {
    case .putBaby:
      return makePathtoURL(path: "/baby")
    }
  }
  
  var param: [String : String?]? {
    switch self {
    case .putBaby(_, let id, let name, let birth, let imageUrl) :
      return ["id": String(id), "name": name, "birth": birth, "imageUrl": imageUrl]
    }
  }
  
  func makePathtoURL(path: String?) -> String {
    return NetworkManager.baseUrl + "\(path ?? "")"
  }
}
