//
//  PostApi.swift
//  MOMO
//
//  Created by 오승기 on 2021/12/17.
//

import Foundation

enum PostApi: APIable {
    case registProfile(email: String, password: String, nickname: String, isPregnant: Bool, hasChild: Bool, age: Int, location: String, contentType: ContentType)

    
    var contentType: ContentType {
        switch self {
        case .registProfile(email: _, password: _, nickname: _, isPregnant: _, hasChild: _, age: _, location: _, contentType: let contentType):
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
        switch self {
        case .registProfile:
            return RequestType.post
        }
    }
    
    var url: String {
        switch self {
        case .registProfile:
            return "http://localhost:5001/momo-test-a4b5f/asia-northeast3/api/auth/signup"
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
        }
    }
  
  var header: [String : String]? {
    switch self {
    default:
      return nil
    }
  }
}
