//
//  PolicyData.swift
//  MOMO
//
//  Created by abc on 2022/01/01.
//

import Foundation

struct PolicyData: Codable, simpleContent {
  
  var id: Int
  var title: String
  var author: String?
  var location: String
  var filter: [Filter]
  var createdAt: String
  var updatedAt: String
  var url: String?
  var fileUrl: [String]
  var content: String
  var thumbnailImageUrl: String?
  var imageUrl: [String]
  var isBookmark: Bool
  
  enum CodingKeys: String, CodingKey {
    case id, title, author, location, createdAt, updatedAt, url, fileUrl, content, thumbnailImageUrl, imageUrl, isBookmark
    case filter = "category"
  }
}

extension PolicyData {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(Int.self, forKey: .id)) ?? -1
    title = (try? container.decode(String.self, forKey: .title)) ?? ""
    author = try? container.decode(String?.self, forKey: .author)
    location = (try? container.decode(String.self, forKey: .location)) ?? "Seoul"
    filter = (try? container.decode([Filter].self, forKey: .filter)) ?? []
    thumbnailImageUrl = try? container.decode(String?.self, forKey: .thumbnailImageUrl)
    url = try? container.decode(String?.self, forKey: .url)
    imageUrl = (try? container.decode([String].self, forKey: .imageUrl)) ?? []
    fileUrl = (try? container.decode([String].self, forKey: .fileUrl)) ?? []
    content = (try? container.decode(String?.self, forKey: .content)) ?? ""
    isBookmark = (try? container.decode(Bool.self, forKey: .isBookmark)) ?? false
    createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
    updatedAt = (try? container.decode(String.self, forKey: .updatedAt)) ?? ""
  }
}

enum Filter: String, Codable {
  case law
  case economy
  case medical
  case home
  case unknown
  
  static func getCase(korean: String) -> Filter {
    switch korean {
    case "법률":
      return Filter.law
    case "경제":
      return Filter.economy
    case "의료":
      return Filter.medical
    case "주거":
      return Filter.home
    default:
      return Filter.unknown
    }
  }
}
