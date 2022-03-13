//
//  DeleteApi.swift
//  MOMO
//
//  Created by abc on 2021/12/28.
//

import Foundation

enum DeleteApi {
  case deleteUser(token: String)
  case deleteBookmark(token: String, postId: Int, postCategory: Category)
}

extension DeleteApi: APIable {
  var contentType: ContentType {
    switch self {
    case .deleteUser:
      return .noBody
    case .deleteBookmark:
      return .jsonData
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
    case .deleteUser(let token), .deleteBookmark(let token, _, _):
      return [ "Authorization" : "Bearer \(token)"]
    }
  }
  
  var url: String {
    switch self {
    case .deleteUser:
      return makePathtoURL(path: "/member")
    case .deleteBookmark:
      return makePathtoURL(path: "/bookmark")
    }
  }
  
  var param: [String : String?]? {
    switch self {
    case .deleteBookmark(_, let postId, let postCategory):
      return ["postId": String(postId), "postCategory": postCategory.rawValue]
    default:
      return nil
    }
  }
  
  func makePathtoURL(path: String?) -> String {
    return APIInfo.baseURL + "\(path ?? "")"
  }
}
