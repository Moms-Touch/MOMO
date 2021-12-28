//
//  BabyData.swift
//  MOMO
//
//  Created by abc on 2021/12/09.
//

import Foundation

struct BabyData: Codable {
  let id: Int
  let name: String
  let birth: String?
  let imageURL: String?
  let createdAt: String
  let updatedAt: String
  
  enum CodingKeys: String, CodingKey {
    case id, name, birth, imageURL, createdAt, updatedAt
  }
}

extension BabyData {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(Int.self, forKey: .id)) ?? -1
    name = (try? container.decode(String.self, forKey: .name)) ?? ""
    birth = try? container.decode(String.self, forKey: .birth)
    imageURL = try? container.decode(String.self, forKey: .imageURL)
    createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
    updatedAt = (try? container.decode(String.self, forKey: .updatedAt)) ?? ""
  }
}

