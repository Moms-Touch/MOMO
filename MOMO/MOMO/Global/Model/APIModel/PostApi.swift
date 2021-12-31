//
//  PostApi.swift
//  MOMO
//
//  Created by 오승기 on 2021/12/17.
//

// 설명: POSTAPI를 작성하는 곳이다.
// encodingType에서는 URLEncoding 이나 JSONEncoding을 정한다. Path variable은 그냥 url에서 작성한다.
// contentType에서는 웬만하면 다 application/json으로 갈 것이다.
// 하지만 api 설계서에 urlencoding 방식이라면 contenttype이 urlencoding으로 하면된다.
// queryString일 경우에는 encodingType을 URLEncoding으로 작성한다.
// header을 통해서 Bearer token을 추가해준다.
// param을 통해서 req에 넘겨줄 데이터를 보여준다.

import Foundation

enum PostApi: APIable {
    case registProfile(email: String, password: String, nickname: String, isPregnant: Bool, hasChild: Bool, age: Int, location: String, contentType: ContentType)
    case login(email: String, password: String, contentType: ContentType)
    case findPassword(email: String, contentType: ContentType)
    
    var contentType: ContentType {
        switch self {
        case .registProfile(email: _, password: _, nickname: _, isPregnant: _, hasChild: _, age: _, location: _, contentType: let contentType):
            return contentType
        case .login(_, _, contentType: let contentType):
            return contentType
        case .findPassword( _, contentType: let contentType):
            return contentType
        }
    }
  
  var encodingType: EncodingType {
    switch self {
    case .registProfile:
      return .JSONEncoding
    default:
      return .JSONEncoding
    }
  }
    
    var requestType: RequestType {
        return RequestType.post
    }
    
    var url: String {
        switch self {
        case .registProfile:
            return makePathtoURL(path: "/auth/signup")
        case .login(email: let email, password: let password, contentType: let contentType):
            return makePathtoURL(path: "/auth/login")
        case .findPassword(email: let email, contentType: let contentType):
            return makePathtoURL(path: "/auth/password")
        }
    }
    
    var param: [String : String?]? {
        switch self {
        case .registProfile(email: let email, password: let password, nickname: let nickname, isPregnant: let isPregnant, hasChild: let hasChild, age: let age, location: let location, contentType: _):
            return ["email": email,
                    "password": password,
                    "nickname": nickname,
                    "isPregnant": isPregnant.description,
                    "hasChild": hasChild.description,
                    "age": age.description,
                    "location": location
                    ]
        case .login(email: let email, password: let password, contentType: _):
            return ["email": email,
                    "password": password]
        case .findPassword(email: let email, contentType: _):
            return ["email": email]
        }
    }
  
  var header: [String : String]? {
    switch self {
    default:
      return nil
    }
  }
  
  func makePathtoURL(path: String?) -> String {
    return NetworkManager.baseUrl + "\(path ?? "")"
  }
}
