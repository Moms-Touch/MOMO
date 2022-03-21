//
//  URL+Extension.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation

extension URL {
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
