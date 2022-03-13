//
//  Post.swift
//  MOMO
//
//  Created by abc on 2021/12/26.
//

import Foundation

struct Post: Codable, simpleContent {
  
  var id: Int
  var title: String
  var author: String?
  var category: Category
  var thumbnailImageUrl: String?
  var url: String?
  var createdAt: String
  var updatedAt: String
  
  enum CodingKeys: String, CodingKey {
    case id, title, author, category, thumbnailImageUrl, createdAt, updatedAt, url
  }
}

extension Post {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(Int.self, forKey: .id)) ?? -1
    title = (try? container.decode(String.self, forKey: .title)) ?? ""
    author = try? container.decode(String?.self, forKey: .author)
    category = (try? container.decode(Category.self, forKey: .category)) ?? .unknown
    thumbnailImageUrl = try? container.decode(String?.self, forKey: .thumbnailImageUrl)
    url = try? container.decode(String?.self, forKey: .url)
    createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
    updatedAt = (try? container.decode(String.self, forKey: .updatedAt)) ?? ""
  }
}

