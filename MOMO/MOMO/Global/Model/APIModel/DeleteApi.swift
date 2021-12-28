//
//  DeleteApi.swift
//  MOMO
//
//  Created by abc on 2021/12/28.
//

import Foundation

enum DeleteApi {
  
}

extension DeleteApi: APIable {
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
    return nil
  }
  
  var url: String {
    return makePathtoURL(path: "")
  }
  
  var param: [String : String?]? {
    return nil
  }
  
  func makePathtoURL(path: String?) -> String {
    return NetworkManager.baseUrl + "\(path ?? "")"
  }
}
