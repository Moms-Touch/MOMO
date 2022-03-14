//
//  NetworkProtocol.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation
import RxSwift

protocol NetworkProtocol {
  
  @discardableResult
  func request(apiModel: APIable) -> Single<Data>
  
  @discardableResult
  func request(apiModel: APIable, completion: @escaping URLSessionResult) -> URLSessionTaskProtocol?
}
