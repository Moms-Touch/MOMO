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
  private let userSessionDataStore: UserSessionDataStore

  //MARK: - init
  init(remoteAPI: RecommendRemoteAPI, userSessionDataStore: UserSessionDataStore) {
    self.remoteAPI = remoteAPI
    self.userSessionDataStore = userSessionDataStore
  }
  
  //MARK: - Methods
  
  private func readUserSession() -> Observable<UserSession> {
    return self.userSessionDataStore
      .readUserSession()
      .compactMap { $0 }
      .share()
  }

  func getRecommendInfo(start: Int, end: Int) -> Observable<[InfoData]> {
    
    return readUserSession()
      .map { $0.token }
      .withUnretained(self)
      .flatMap { repository, token -> Observable<[InfoData]> in
        return repository.remoteAPI.fetch(token: token, start: start, end: end)
      }
      .share()

  }
  
  func getDetailRecommendedInfo(id: Int) -> Observable<InfoData> {
    
      return readUserSession()
      .map { $0.token }
      .withUnretained(self)
      .flatMap { repo, token in
        return repo.remoteAPI.fetch(token: token, id: id)
      }
      .share()
      
  }
  
  func bookmark(id: Int, category: Category) -> Observable<Bool> {
    return readUserSession()
      .map { $0.token }
      .withUnretained(self)
      .flatMap { repo, token in
        return repo.remoteAPI.
      }
  }
  
  func unBookmark(id: Int, category: String) -> Observable<Bool> {
    return Observable.empty()
  }
  
}
