//
//  URLSessionProtocol.swift
//  MOMO
//
//  Created by abc on 2022/03/13.
//

import Foundation

protocol URLSessionProtocol: AnyObject {
  
  @available(* ,deprecated)
  func dataTask(with request: URLRequest, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
  
  
  func makeDataTask(with url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol
  
  func makeDataTask(with request: URLRequest, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol
}

protocol URLSessionTaskProtocol: AnyObject {
  func resume()
}

extension URLSessionTask: URLSessionTaskProtocol { }

extension URLSession: URLSessionProtocol {
  func makeDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
    return dataTask(with: url, completionHandler: completionHandler)
  }
  
  func makeDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
    return dataTask(with: request, completionHandler: completionHandler)
  }
}
