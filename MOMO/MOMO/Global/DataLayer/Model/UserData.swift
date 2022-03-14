//
//  UserData.swift
//  MOMO
//
//  Created by abc on 2021/12/28.
//

import Foundation

struct UserData: Codable, Equatable {
  let id: Int
  var email: String
  var nickname: String
  var isPregnant: Bool
  let hasChild: Bool
  var age: Int
  var location: String
  let createdAt: String
  let updatedAt: String
  let baby: [BabyData]?
  
  enum CodingKeys: String, CodingKey {
    case id, email, nickname, isPregnant, hasChild, age, location, baby, createdAt, updatedAt
  }
}

extension UserData {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(Int.self, forKey: .id)) ?? -1
    email = (try? container.decode(String.self, forKey: .email)) ?? ""
    age = (try? container.decode(Int.self, forKey: .age)) ?? 24
    location = (try? container.decode(String.self, forKey: .location)) ?? "Seoul"
    nickname = (try? container.decode(String.self, forKey: .nickname)) ?? "모모"
    isPregnant = (try? container.decode(Bool.self, forKey: .isPregnant)) ?? true
    hasChild = (try? container.decode(Bool.self, forKey: .hasChild)) ?? true
    createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
    updatedAt = (try? container.decode(String.self, forKey: .updatedAt)) ?? ""
    baby = (try? container.decode([BabyData].self, forKey: .baby)) ?? nil //baby가 없으면 nil로 들어올 예정
  }
}

