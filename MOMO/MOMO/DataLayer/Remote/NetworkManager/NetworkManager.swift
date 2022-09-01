//
//  NetworkManager.swift
//  MOMO
//
//  Created by 오승기 on 2021/12/12.
//

import Foundation
import RxSwift

typealias URLSessionResult = ((Result<Data, Error>) -> Void)

class NetworkManager: NetworkProtocol {
  
  //MARK: - init
  
  init(session: URLSessionProtocol = URLSession.shared, coder: NetworkEncoding = NetworkCoder()) {
    self.coder = coder
    self.session = session
  }
  
  //MARK: - Private Properties
  
  private let boundary = "Boundary-\(UUID().uuidString)"
  private let coder: NetworkEncoding
  private let session: URLSessionProtocol
  
  //MARK: - Methods
    
    /// 기존에 있던 request를 Single로 묶어서 rx환경에서 편하게 만듬
    /// - Parameter apiModel: APIable에 정의된 API를 받는다 (API에 대한 정보가 다 있음)
    /// - Returns: Single<Data>
  func request(apiModel: APIable) -> Single<Data> {
    return Single<Data>.create { (single) -> Disposable in
      let request = self.request(apiModel: apiModel) { result in
        switch result {
        case .success(let data):
          single(.success(data))
        case .failure(let error):
          single(.failure(error))
        }
      }
      return Disposables.create()
    }
  }

}

//MARK: - RequestHelperMethod - reqeust

extension NetworkManager {
  // TODO: refactor 끝난뒤에는 private으로 바꾸기
    @discardableResult
    func request(apiModel: APIable, completion: @escaping URLSessionResult) -> URLSessionTaskProtocol? {
      
      var url: URL!
      
      //MARK: - EncodingType
      switch apiModel.encodingType {
      case .URLEncoding: // urlEncoding.QueryString형식으로 url 만들기
        guard let tempUrl = URL.URLEncodingType(parameters: apiModel.param, url: apiModel.url) else {
          completion(.failure(NetworkError.invalidURL))
          return nil
        }
        url = tempUrl
          
      case .JSONEncoding: //JSONEncoding일때는 그냥 url만들기
        guard let tempUrl = URL(string: apiModel.url) else {
          completion(.failure(NetworkError.invalidURL))
          return nil
        }
        url = tempUrl
          
      default: // formdata 돌릴때 그냥 URL를 만들기
          guard let tempUrl = URL(string: apiModel.url) else {
            completion(.failure(NetworkError.invalidURL))
            return nil
          }
          url = tempUrl
      }
         
      //MARK: - URLRequest
      var request = URLRequest(url: url)
      request.httpMethod = apiModel.requestType.method
      request.httpBody = createDataBody(parameter: apiModel.param, contentType: apiModel.contentType, url: apiModel.url)
      
      //MARK: - ContentType
      switch apiModel.contentType {
      case .multiPartForm:
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
      case .jsonData:
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      case .HTMLform:
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      case .noBody:
        break
      }
      
      //MARK: - Headers

      if let header = apiModel.header {
        header.forEach { request.addValue($1, forHTTPHeaderField: $0)}
      }

      //MARK: - Task
      let task = session.makeDataTask(with: request) { data, response, error in
        
        if let error = error {
          completion(.failure(error))
          return
        }
        
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
          completion(.failure(NetworkError.failResponse))
          return
        }
        
        guard let data = data else {
          completion(.failure(NetworkError.invalidData))
          return
        }
        completion(.success(data))
        
      }
      
      task.resume()
      return task
    }
}

//MARK: - Private Methods

extension NetworkManager {
    
    /// 각 contentType에 대한 body를 만드는 함수
    /// - Parameters:
    ///   - parameter: body를 만드는데 필요한 key, value
    ///   - contentType: contentType (Multipart, json, HTMLform)
    ///   - url: url
    /// - Returns: Data (body data)
  private func createDataBody(parameter: [String: String?]?, contentType: ContentType, url: String) -> Data? {
    var body = Data()
    let lineBreak = "\r\n"
    
    if let modelParameter = parameter {
      switch contentType {
      case .multiPartForm:
        for (key, value) in modelParameter {
          body.append(convertTextField(key: key, value: "\(value ?? "")"))
        }
        body.append("--\(boundary)--\(lineBreak)")
      case .jsonData:
        if let data = coder.encode(parameters: parameter){
          body = data
        }
      case .HTMLform:
        if let data = coder.encode(parameters: parameter, url: url){
          body = data
        }
      case .noBody:
        return nil
      }
      return body
    } else {
      return nil
    }
  }
  
  private func convertFileField(key: String, source: String, mimeType: String, value: Data) -> Data {
    let lineBreak = "\r\n"
    var dataField = Data()
    
    dataField.append("--\(boundary + lineBreak)")
    dataField.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(source)\"\(lineBreak)")
    dataField.append("Content-Type: \(mimeType + lineBreak + lineBreak)")
    dataField.append(value)
    dataField.append(lineBreak)
    
    return dataField
  }
  
  private func convertTextField(key: String, value: String) -> Data {
    let lineBreak = "\r\n"
    var textField = Data()
    
    textField.append("--\(boundary + lineBreak)")
    textField.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
    textField.append("\(value)\(lineBreak)")
    
    return textField
  }
}

extension Data {
  mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      append(data)
    }
  }
}


