//
//  GenericResponse.swift
//  MOMO
//
//  Created by abc on 2021/12/21.
//

import Foundation

struct SimpleResponse: Codable {
  var status: Int
  var success: Bool
  var message: String
  
  enum CodingKeys: String, CodingKey {
    case status, success, message
  }
}

extension SimpleResponse {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.status = (try? container.decode(Int.self, forKey: .status)) ?? 400
    self.success = (try? container.decode(Bool.self, forKey: .success)) ?? false
    self.message = (try? container.decode(String.self, forKey: .message)) ?? " "
  }
}
