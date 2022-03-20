//
//  RecommendRepository.swift
//  MOMO
//
//  Created by abc on 2022/03/20.
//

import Foundation
import RxSwift

protocol RecommendRepository {
  
  @discardableResult
  func getRecommendInfo() -> Observable<InfoData>
  
  @discardableResult
  func bookmark(id: Int, category: String) -> Observable<Bool>
  
  @discardableResult
  func unBookmark(id: Int, category: String) -> Observable<Bool>
  
}
