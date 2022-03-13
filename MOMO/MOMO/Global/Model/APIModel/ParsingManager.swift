//
//  ParsingManager.swift
//  MOMO
//
//  Created by 오승기 on 2021/12/12.
//

import Foundation

enum JsonError: Error {
  case decodingError
  case encodingError
}

enum EncodingType {
  case URLEncoding
  case JSONEncoding
}

struct ParsingManager {
  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  
  func decodingData<T:Decodable>(data: Data, model: T.Type) -> T? {
    let convertedModel = try? decoder.decode(T.self, from: data)
    return convertedModel
  }
  
  func judgeGenericResponse<T: Codable>(data: Data, model: T.Type, completion: @escaping((T) -> Void)) {
    let body = try? decoder.decode(GenericResponse<T>.self, from: data)
    guard let bodyData = body?.data else {
      return
    }
    completion(bodyData)
  }
  
  func judgeSimpleResponse(data: Data, completion: @escaping(() -> Void)) {
    let body = try? decoder.decode(SimpleResponse.self, from: data)
    completion()
  }
  
  
  func encodingModel(parameters: [String: String?]?) -> Data? {
    let convertedData = try? encoder.encode(parameters)
    return convertedData
  }
  
  func URLEncodingModelWithQueryString(parameters: [String: String?]?, url: String) -> Data? {
    let url = url
    guard let parameters = parameters else {
      return url.data(using: .utf8)
    }
    var arr = [String]()
    for (key, value) in parameters {
      guard let value = value else {
        continue
      }
      arr.append("\(key)=\(value)")
    }
    let formDataString = arr.joined(separator: "&")
    print(formDataString)
    return formDataString.data(using: .utf8)
  }
  
  // URLEncoding, nobody
  func URLEncoding(parameters: [String: String?]?, url: String) -> URL? {
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
