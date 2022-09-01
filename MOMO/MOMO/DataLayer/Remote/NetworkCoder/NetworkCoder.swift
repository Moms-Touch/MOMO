//
//  ParsingManager.swift
//  MOMO
//
//  Created by abc on 2021/12/12.
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
    
    /// Data 형식으로 들어오는 네트워크 통신 결과를 decode 하는 API
    /// - Parameters:
    ///   - data: Data, 주로 네트워크 통신의 결과
    ///   - model: 어떤 모델로 decode로 할 것인지, 즉 decode의 형식, DTO
    /// - Returns: 파라미터로 전달한 모델의 형식을 감싼 Observable
  func decode<T>(data: Data, model: T.Type) -> Observable<T> where T : Decodable, T : Encodable {
    
    return Observable<T>.create { observer in
      
      let decoder = JSONDecoder()
      guard let body = try? decoder.decode(GenericResponse<T>.self, from: data) else {
        return observer.onError(NetworkError.invalidData) as! Disposable
      }
      guard let bodyData = body.data else {
        return observer.onError(NetworkError.invalidData) as! Disposable
      }
      observer.onNext(bodyData)
      observer.onCompleted()
      
      return Disposables.create()
    }

  }
    
    /// 딕셔너리를 JSON 형식으로 변환하는 API
    /// - Parameter parameters: [KEY:VALUE]
    /// - Returns: JSON 데이터
  func encode(parameters: [String: String?]?) -> Data? {
    let convertedData = try? encoder.encode(parameters)
    return convertedData
  }
    
    /// 딕셔너리를 query parameter 형식으로 변환하는 API
    /// - Parameters:
    ///   - parameters: 쿼리문의 [KEY: VALUE]
    ///   - url: 쿼리문에 아무것도 없다면, 단순 URL를 활용해서 JSON 데이터를 return
    /// - Returns: JSON 데이터
  func encode(parameters: [String: String?]?, url: String) -> Data? {
    let url = url
    guard let parameters = parameters else {
        return nil
//      return url.data(using: .utf8)
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
