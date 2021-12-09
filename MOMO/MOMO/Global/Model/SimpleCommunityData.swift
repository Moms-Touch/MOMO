//
//  CommunityData.swift
//  MOMO
//
//  Created by abc on 2021/12/08.
//

import Foundation

struct SimpleCommunityData: Codable, simpleContent {
  let id: Int
  let author: String
  let thumbnailImageUrl: String
  let createdAt: String
  let updatedAt: String
}
