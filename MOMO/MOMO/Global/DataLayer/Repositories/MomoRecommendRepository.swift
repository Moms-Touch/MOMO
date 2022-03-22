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
  @discardableResult
  private func readUserSession() -> Observable<UserSession> {
    return self.userSessionDataStore
      .readUserSession()
      .compactMap { $0 }
      .share()
  }
  
  @discardableResult
  func getRecommendInfo(start: Int, end: Int) -> Observable<[InfoData]> {
    return readUserSession()
      .map { $0.token }
      .withUnretained(self)
      .flatMap { repository, token -> Observable<[InfoData]> in
        return repository.remoteAPI.fetch(token: token, start: start, end: end)
      }
      .share()
  }
  
  @discardableResult
  func getRecommendInfo() -> Observable<[InfoData]> {
    
    return readUserSession()
      .map{ usersession -> (Token, String?) in
        return usersession.profile.isPregnant == true ? (usersession.token, usersession.profile.baby?.first?.birthday?.trimStringDate().fetusInWeek()) : (usersession.token, usersession.profile.baby?.first?.birthday?.trimStringDate().babyInWeek())
      }
      .flatMap{ [weak self] token, babyWeek -> Observable<[InfoData]> in
        
        guard let self = self, let babyWeek = babyWeek else {
          return Observable.empty()
        }
        
        var date: [Int] = []
        
        switch Int(babyWeek.components(separatedBy: "주차")[0])! {
        case 1...8:
          date = [1, 8]
        case 9...16:
          date = [9, 16]
        case 17...24:
          date = [17, 24]
        case 25...32:
          date = [25, 32]
        case 33...40:
          date = [33, 40]
        default:
          date = [1, 8]
        }
        
        return self.remoteAPI.fetch(token: token, start: date[0], end: date[1])
          .share()
        
      }
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
  
  func bookmark(id: Int, category: Category) -> Completable {
    return readUserSession()
      .map { $0.token }
      .withUnretained(self)
      .flatMap { repo, token in
        return repo.remoteAPI.bookmark(token: token, id: id, category: category)
      }
      .asCompletable()
    
    
  }
  
  func unBookmark(id: Int, category: Category) -> Completable {
    return readUserSession()
      .map { $0.token }
      .withUnretained(self)
      .flatMap { repo, token in
        return repo.remoteAPI.unbookmark(token: token, id: id, category: category)
      }
      .asCompletable()
  }
  
}
