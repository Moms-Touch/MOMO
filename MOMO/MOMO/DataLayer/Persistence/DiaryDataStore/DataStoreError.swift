//
//  DataStoreError.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/26.
//

import Foundation

enum DataStoreError: Error {
  case noResult
  case realmFailure
  case deleteError
}
