//
//  LikeData.swift
//  MOMO
//
//  Created by abc on 2021/12/08.
//

import Foundation

struct LikeData: Codable {
  let community: SimpleCommunityData?
  let createdAt: String
}

extension LikeData {
  enum CodingKeys: String, CodingKey {
    case community, createdAt
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    community = try? container.decode(SimpleCommunityData.self, forKey: .community)
    createdAt = (try? container.decodeIfPresent(String.self, forKey: .createdAt)) ?? ""
  }

}
