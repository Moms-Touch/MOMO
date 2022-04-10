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
  func getRecommendInfo(start: Int, end: Int) -> Observable<[InfoData]>
  
  @discardableResult
  func getRecommendInfo() -> Observable<[InfoData]>
  
  @discardableResult
  func getDetailRecommendedInfo(id: Int) -> Observable<InfoData>
  
  @discardableResult
  func bookmark(id: Int, category: Category) -> Completable
  
  @discardableResult
  func unBookmark(id: Int, category: Category) -> Completable
  
}
