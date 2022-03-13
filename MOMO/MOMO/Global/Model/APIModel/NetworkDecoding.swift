//
//  NetworkDecoding.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation

protocol NetworkDecoding {
  func decode<T>(data: Data, model: T.Type) -> Observable<T> where T : Decodable, T : Encodable
}
