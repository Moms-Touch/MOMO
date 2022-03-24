//
//  CommunityData.swift
//  MOMO
//
//  Created by abc on 2021/12/08.
//

import Foundation

struct SimpleCommunityData: Codable, simpleContent {
  var id: Int
  var title: String
  var author: String?
  var thumbnailImageUrl: String?
  var isValid: Bool
  var isDeleted: Bool
  var url: String?
  var createdAt: String
  let updatedAt: String
}

extension SimpleCommunityData {
  enum CodingKeys: String, CodingKey {
    case id, title, thumbnailImageUrl, url, createdAt, updatedAt, isValid, isDeleted
    case author = "nickname"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(Int.self, forKey: .id)) ?? -1
    title = (try? container.decode(String.self, forKey: .title)) ?? ""
    url = (try? container.decode(String?.self, forKey: .url))
    author = try? container.decode(String?.self, forKey: .author)
    thumbnailImageUrl = try? container.decode(String?.self, forKey: .thumbnailImageUrl)
    createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
    updatedAt = (try? container.decode(String.self, forKey: .updatedAt)) ?? ""
    isValid = (try? container.decode(Bool.self, forKey: .updatedAt)) ?? true
    isDeleted = (try? container.decode(Bool.self, forKey: .updatedAt)) ?? false
  }
}
