//
//  GenericResponse.swift
//  MOMO
//
//  Created by abc on 2021/12/21.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
  var status: Int
  var success: Bool
  var message: String
  var data: T?
  
  enum CodingKeys: String, CodingKey {
    case status, success, message, data
  }
}

extension GenericResponse {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.status = (try? container.decode(Int.self, forKey: .status)) ?? 400
    self.success = (try? container.decode(Bool.self, forKey: .success.self)) ?? false
    self.message = (try? container.decode(String.self, forKey: .message.self)) ?? " "
    // data 값이 없ㄷㅏ면 nil 반환
    self.data = (try? container.decode(T.self, forKey: .data.self)) ?? nil
  }
}
