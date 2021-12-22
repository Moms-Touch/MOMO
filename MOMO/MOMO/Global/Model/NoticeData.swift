//
//  NoticeData.swift
//  MOMO
//
//  Created by abc on 2021/12/08.
//

import Foundation

struct NoticeData: Codable {
  let id: Int
  let author: String
  let title: String
  let url: String
  let createdAt: String
  let updatedAt: String
}

extension NoticeData {
  enum CodingKeys: String, CodingKey {
    case id, author, title, url, createdAt, updatedAt
  }
}
