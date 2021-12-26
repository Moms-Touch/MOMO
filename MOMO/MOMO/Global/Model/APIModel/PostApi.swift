//
//  PostApi.swift
//  MOMO
//
//  Created by 오승기 on 2021/12/17.
//

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
    
    var requestType: RequestType {
        return RequestType.post
    }
    
    var url: String {
        switch self {
        case .registProfile:
            return "https://asia-northeast3-momo-test-a4b5f.cloudfunctions.net/api/auth/signup"
        case .login:
            return "https://asia-northeast3-momo-test-a4b5f.cloudfunctions.net/api/auth/login"
        case .findPassword(email: let email, contentType: let contentType):
            return "https://asia-northeast3-momo-test-a4b5f.cloudfunctions.net/api/auth/password"
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
}
