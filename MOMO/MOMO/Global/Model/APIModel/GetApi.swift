//
//  GetApi.swift
//  MOMO
//
//  Created by 오승기 on 2021/12/16.
//

// 설명: GetAPI를 작성하는 곳이다.
// encodingType에서는 URLEncoding 이나 JSONEncoding을 정한다. Path variable은 그냥 url에서 작성한다.
// queryString일 경우에는 encodingType을 URLEncoding으로 작성한다.
// header을 통해서 Bearer token을 추가해준다.
// param을 통해서 req에 넘겨줄 데이터를 보여준다.

import Foundation

enum GetApi: APIable {
  
  case login
  case babyGet
  case bookmarkGet
  case communityGet
  case communityDetailGet
  case noticeGet
  case policyGet(token: String, keyword: String?, location: String?, category: String?, page: String?)
  //Infoget밑으로 안함
}

extension GetApi {
  
  var contentType: ContentType {
    switch self {
    case .noticeGet, .policyGet:
      return .noBody
    default:
      return .noBody
    }
  }
  
  var encodingType: EncodingType {
    switch self {
    case .noticeGet:
      return .JSONEncoding
    case .policyGet:
      return .URLEncoding
    default:
      return .URLEncoding
    }
  }
  
  var requestType: RequestType {
    return .get
  }
  
  var url: String {
    switch self {
    case .noticeGet:
      return makePathtoURL(path: "/notice")
    case .policyGet:
      return makePathtoURL(path: "/policy")
    default:
      return " "
    }
  }
  
  var param: [String : String?]? {
    switch self {
    case .noticeGet:
      return nil
    case .policyGet(_, let keyword, let location, let category, let page):
      return ["keyword": keyword, "location": location, "category": category, "page": page]
    default:
      return nil
    }
  }
  
  var header: [String : String]? {
    switch self {
    case .noticeGet:
      return nil
    case .policyGet(let token, _, _, _, _):
      return [ "Authorization" : "Bearer \(token)"]
    default:
      return nil
    }
  }
  
  func makePathtoURL(path: String?) -> String {
    return NetworkManager.baseUrl + "\(path ?? "")"
  }
}
