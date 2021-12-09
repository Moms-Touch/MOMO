//
//  RecommendSimpleData.swift
//  MOMO
//
//  Created by abc on 2021/11/25.
//

import Foundation

struct InfoData: simpleContent, Codable {
  let infoId: Int
  let author: String
  let title: String
  let url: String
  let thumbnailImageURL: String?
  let week: Int
  let createdAt: String
  let updatedAt: String
}

extension InfoData{
  enum CodingKeys: String, CodingKey {
    case infoId = "id"
    case author, title, url
    case thumbnailImageURL = "thumbnail_image_url"
    case week
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}

extension InfoData {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    infoId = (try? container.decode(Int.self, forKey: .infoId)) ?? -1
    author = (try? container.decodeIfPresent(String.self, forKey: .author)) ?? ""
    title = (try? container.decodeIfPresent(String.self, forKey: .title)) ?? ""
    url = (try? container.decodeIfPresent(String.self, forKey: .url)) ?? ""
    thumbnailImageURL = try? container.decodeIfPresent(String.self, forKey: .thumbnailImageURL)
    week = (try? container.decodeIfPresent(Int.self, forKey: .week)) ?? 0
    createdAt = (try? container.decodeIfPresent(String.self, forKey: .createdAt)) ?? ""
    updatedAt = (try? container.decodeIfPresent(String.self, forKey: .updatedAt)) ?? ""
  }
}
