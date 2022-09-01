//
//  URLSessionProtocol.swift
//  MOMO
//
//  Created by abc on 2022/03/13.
//

import Foundation

/// URLSessionProtocol을 만드는 이유는 URLSession을 상속받아서 init을 만들 수 없기 때문이다. 그렇기 때문에 URLSession을 mock하고 싶다면, URLSessionProtocol을 채택한 MockURLSession을 만들어야하기 때문에, URLSessionProtocol을 만든것!
protocol URLSessionProtocol: AnyObject {
  
  @available(* ,deprecated)
  func dataTask(with request: URLRequest, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
  
  
  func makeDataTask(with url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol
  
  func makeDataTask(with request: URLRequest, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol
}

/// URLSessionTaskProtocol을 만드는 이유는 URLSessionTask를 mock하기 위해서
protocol URLSessionTaskProtocol: AnyObject {
  func resume()
}

extension URLSessionTask: URLSessionTaskProtocol { }

extension URLSession: URLSessionProtocol {
    
    /// makeDataTask를 활용해서 dataTask를 빼낸다. dataTask는 URLSessionDataTask를 return하는데 이는 URLSessionTaskProtocol을 채택하고 있다. 이렇게 Return을 URLSessionTaskProtocol을 하면서 URLSessionTaskProtocol을 채택한 어떠한 객체를 빼도 되기 때문에 mock을 하기에 유용하다.
    /// - Parameters:
    ///   - url: URL
    ///   - completionHandler: (Data?, URLResponse?, Error?) -> Void 로 caller에서 처리할 때, Data로 뭐할것인지, Error로 뭐할것인지, URLResponse로 뭐할 것인지 적을 수 있다.
    /// - Returns: URLSessionTaskProtocol
  func makeDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
    return dataTask(with: url, completionHandler: completionHandler)
  }
  
    
    /// makeDataTask를 활용해서 dataTask를 빼낸다. dataTask는 URLSessionDataTask를 return하는데 이는 URLSessionTaskProtocol을 채택하고 있다. 이렇게 Return을 URLSessionTaskProtocol을 하면서 URLSessionTaskProtocol을 채택한 어떠한 객체를 빼도 되기 때문에 mock을 하기에 유용하다.
    /// - Parameters:
    ///   - request: URLRequest를 만들어서 param으로 던지기
    ///   - completionHandler: (Data?, URLResponse?, Error?) -> Void 로 caller에서 처리할 때, Data로 뭐할것인지, Error로 뭐할것인지, URLResponse로 뭐할 것인지 적을 수 있다.
    /// - Returns: URLSessionTaskProtocol
  func makeDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
    return dataTask(with: request, completionHandler: completionHandler)
  }
}
