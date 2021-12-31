//
//  RecommendSimpleData.swift
//  MOMO
//
//  Created by abc on 2021/11/25.
//

import Foundation

struct InfoData: simpleContent, Codable {  
  var id: Int
  var author: String?
  var title: String
  var url: String?
  var thumbnailImageUrl: String?
  var isBookmark: Bool
  let week: Int
  var createdAt: String
  let updatedAt: String
}

extension InfoData{
  enum CodingKeys: String, CodingKey {
    case id, author, title, url, thumbnailImageUrl, week, createdAt, updatedAt, isBookmark
  }
}

extension InfoData {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(Int.self, forKey: .id)) ?? -1
    author = (try? container.decodeIfPresent(String.self, forKey: .author)) ?? ""
    title = (try? container.decodeIfPresent(String.self, forKey: .title)) ?? ""
    url = (try? container.decodeIfPresent(String.self, forKey: .url)) ?? ""
    thumbnailImageUrl = try? container.decodeIfPresent(String.self, forKey: .thumbnailImageUrl)
    week = (try? container.decodeIfPresent(Int.self, forKey: .week)) ?? 0
    createdAt = (try? container.decodeIfPresent(String.self, forKey: .createdAt)) ?? ""
    updatedAt = (try? container.decodeIfPresent(String.self, forKey: .updatedAt)) ?? ""
    isBookmark = try container.decodeIfPresent(Bool.self, forKey: .isBookmark) ?? false
  }
}
