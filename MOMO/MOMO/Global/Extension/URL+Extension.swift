//
//  URL+Extension.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation

extension URL {
    
    /// 딕셔너리를 query parameter 형식으로 변환하는 API
    /// - Parameters:
    ///   - parameters: 쿼리문의 [KEY: VALUE]
    ///   - url: 쿼리문에 아무것도 없다면, 단순 URL를 활용해서 JSON 데이터를 return
    /// - Returns: JSON 데이터
  static func URLEncodingType(parameters: [String: String?]?, url: String) -> URL? {
    var components = URLComponents(string: url)
    guard let parameters = parameters else {
      return components?.url
    }
    var queryItems: [URLQueryItem] = []
    for (key, value) in parameters {
      queryItems.append(URLQueryItem(name: key, value: value))
    }
    components?.queryItems = queryItems
    return components?.url
  }
}
