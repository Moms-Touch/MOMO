//
//  BabyData.swift
//  MOMO
//
//  Created by abc on 2021/12/09.
//

import Foundation

struct BabyData: Codable, Equatable {
  let id: Int
  let name: String
  let birthday: String?
  let imageUrl: String?
  let createdAt: String
  let updatedAt: String
  
  enum CodingKeys: String, CodingKey {
    case id, name, birthday, imageUrl, createdAt, updatedAt
  }
}

extension BabyData {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(Int.self, forKey: .id)) ?? -1
    name = (try? container.decode(String.self, forKey: .name)) ?? ""
    birthday = try? container.decode(String.self, forKey: .birthday)
    imageUrl = try? container.decode(String.self, forKey: .imageUrl)
    createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
    updatedAt = (try? container.decode(String.self, forKey: .updatedAt)) ?? ""
  }
}

