//
//  ParsingManager.swift
//  MOMO
//
//  Created by 오승기 on 2021/12/12.
//

import Foundation
import RxSwift

class NetworkCoder: NetworkEncoding, NetworkDecoding {
  
  //MARK: - Private Properties

  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  
  //MARK: - init

  public init() { }
  
  //MARK: - Methods

  @available(*, deprecated)
  func judgeGenericResponse<T: Codable>(data: Data, model: T.Type, completion: @escaping((T) -> Void)) {
    let body = try? decoder.decode(GenericResponse<T>.self, from: data)
    guard let bodyData = body?.data else {
      return
    }
    completion(bodyData)
  }
  
  func decode<T>(data: Data, model: T.Type) -> Observable<T> where T : Decodable, T : Encodable {
    
    return Observable<T>.create { observer in
      
      let decoder = JSONDecoder()
      guard let body = try? decoder.decode(T.self, from: data) else {
        return observer.onError(NetworkError.invalidData) as! Disposable
      }
      
      observer.onNext(body)
      observer.onCompleted()
      
      return Disposables.create()
    }

  }
  
  func encode(parameters: [String: String?]?) -> Data? {
    let convertedData = try? encoder.encode(parameters)
    return convertedData
  }
  
  func encode(parameters: [String: String?]?, url: String) -> Data? {
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
    return formDataString.data(using: .utf8)
  }
}
