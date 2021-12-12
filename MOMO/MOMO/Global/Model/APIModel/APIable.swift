//
//  APIable.swift
//  MOMO
//
//  Created by 오승기 on 2021/12/12.
//

import Foundation

import Foundation

protocol APIable {
    var contentType: ContentType { get }
    var requestType: RequestType { get }
    var url: String { get }
    var param: [String: String?]? { get }
}

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
    
    var method: String {
        return self.rawValue
    }
}

enum ContentType {
    case multiPartForm
    case jsonData
    case noBody
    
    var description: String {
        switch self {
        case .multiPartForm:
            return "multipart/form-data"
        case .jsonData:
            return "aplication/json"
        case .noBody:
            return ""
        }
    }
}
