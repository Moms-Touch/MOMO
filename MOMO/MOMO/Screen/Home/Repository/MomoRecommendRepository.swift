//
//  MomoRecommendRepository.swift
//  MOMO
//
//  Created by abc on 2022/03/20.
//

import Foundation
import RxSwift

class MomoRecommendRepository: RecommendRepository {
  
  //MARK: - Private properties
  private let remoteAPI: RecommendRemoteAPI

  
  //MARK: - init
  init(remoteAPI: RecommendRemoteAPI) {
    self.remoteAPI = remoteAPI
  }
  
  //MARK: - Methods
  
  private func readUserSession() -> Observable<(String, UserData)> {
    return Observable.empty()
  }

  func getRecommendInfo() -> Observable<InfoData> {
    return Observable.empty()
  }
  
  func bookmark(id: Int, category: String) -> Observable<Bool> {
    return Observable.empty()
  }
  
  func unBookmark(id: Int, category: String) -> Observable<Bool> {
    return Observable.empty()
  }
  
}
