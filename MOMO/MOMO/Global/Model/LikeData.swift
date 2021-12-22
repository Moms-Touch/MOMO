//
//  LikeData.swift
//  MOMO
//
//  Created by abc on 2021/12/08.
//

import Foundation

struct LikeData: Codable {
  let commmunityData: SimpleCommunityData?
  let createdAt: String
  let updatedAt: String
}

extension LikeData {
  enum CodingKeys: String, CodingKey {
    case commmunityData, createdAt, updatedAt
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    commmunityData = try? container.decode(SimpleCommunityData.self, forKey: .commmunityData)
    createdAt = (try? container.decodeIfPresent(String.self, forKey: .createdAt)) ?? ""
    updatedAt = (try? container.decodeIfPresent(String.self, forKey: .updatedAt)) ?? ""
  }

}
