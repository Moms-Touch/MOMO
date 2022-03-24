//
//  RecommendRemoteAPI.swift
//  MOMO
//
//  Created by abc on 2022/03/20.
//

import Foundation
import RxSwift

protocol RecommendRemoteAPI {
  
  @discardableResult
  func fetch(token: String, start: Int, end: Int) -> Observable<[InfoData]>
  
  @discardableResult
  func fetch(token: String, id: Int) -> Observable<InfoData>
  
  @discardableResult
  func bookmark(token: String, id: Int, category: Category) -> Completable
  
  @discardableResult
  func unbookmark(token: String, id: Int, category: Category) -> Completable
  
}
