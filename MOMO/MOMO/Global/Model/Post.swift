//
//  Post.swift
//  MOMO
//
//  Created by abc on 2021/12/26.
//

import Foundation

struct Post: Codable {
  var id: Int
  var title: String
  var author: String
  var category: Category
  var thumbnailImageUrl: String?
  var createdAt: String
  var updatedAt: String
  
  enum CodingKeys: String, CodingKey {
    case id, title, author, category, thumbnailImageUrl, createdAt, updatedAt
  }
  
  
}

