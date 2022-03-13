//
//  NetworkEncoding.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation

protocol NetworkEncoding {
  func encode(parameters: [String: String?]?) -> Data?
  func encode(parameters: [String: String?]?, url: String) -> Data?
}
