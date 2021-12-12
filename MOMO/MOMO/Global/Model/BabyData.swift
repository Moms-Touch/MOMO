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
  let birth: String
  let imageURL: String?
  let createdAt: String
  let updatedAt: String
  
  enum CodingKeys: String, CodingKey {
    case id, name, birth
    case imageURL = "image_url"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}

