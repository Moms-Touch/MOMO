//
//  DeleteApi.swift
//  MOMO
//
//  Created by abc on 2021/12/28.
//

import Foundation

enum DeleteApi {
  case deleteUser(token: String)
}

extension DeleteApi: APIable {
  var contentType: ContentType {
    switch self {
    case .deleteUser:
      return .noBody
    default:
      return .noBody
    }
  }
  
  var requestType: RequestType {
    .delete
  }
  
  var encodingType: EncodingType {
    return .JSONEncoding
  }
  
  var header: [String : String]? {
    switch self {
    case .deleteUser(let token):
      return [ "Authorization" : "Bearer \(token)"]
    }
  }
  
  var url: String {
    switch self {
    case .deleteUser:
      return makePathtoURL(path: "/memeber")
    }
  }
  
  var param: [String : String?]? {
    return nil
  }
  
  func makePathtoURL(path: String?) -> String {
    return NetworkManager.baseUrl + "\(path ?? "")"
  }
}
