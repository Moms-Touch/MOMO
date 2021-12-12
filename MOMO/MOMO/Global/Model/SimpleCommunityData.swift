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
  var createdAt: String
  let updatedAt: String
}
