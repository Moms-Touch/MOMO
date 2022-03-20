//
//  MomoRecommendRemoteAPI.swift
//  MOMO
//
//  Created by abc on 2022/03/20.
//

import Foundation
import RxSwift

final class MomoRecommendRemoteAPI: RecommendRemoteAPI {
  
  //MARK: - Private Properties
  //TODO: 머지후에 변경하기
  let networkManager: NetworkManager
  
  //MARK: - init
  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }
  
  //MARK: - Methods
  
  func fetch(token: String, start: Int, end: Int) -> Observable<[InfoData]> {
    return Observable.empty()
  }
  
  func fetch(token: String, id: Int) -> Observable<InfoData> {
    return Observable.empty()
  }
  
  func bookmark(token: String, id: Int, category: String) -> Observable<Bool> {
    return Observable.just(true)
  }
  
  func unbookmark(token: String, id: Int, category: String) -> Observable<Bool> {
    return Observable.just(true)
  }

}
