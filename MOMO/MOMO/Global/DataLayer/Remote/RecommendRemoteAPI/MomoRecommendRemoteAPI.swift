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

  private let networkManager: NetworkProtocol
  private let decoder: NetworkDecoding
  
  //MARK: - init
  init(networkManager: NetworkProtocol, decoder: NetworkDecoding) {
    self.networkManager = networkManager
    self.decoder = decoder
  }
  
  //MARK: - Methods
  
  func fetch(token: String, start: Int, end: Int) -> Observable<[InfoData]> {
    return networkManager.request(apiModel: GetApi.infoGet(token: token, start: "\(start)", end: "\(end)"))
      .asObservable()
      .withUnretained(self)
      .flatMap { remoteAPI, data in
        return remoteAPI.decoder.decode(data: data, model: [InfoData].self)
      }
      .share()
  }
  
  func fetch(token: String, id: Int) -> Observable<InfoData> {
    return networkManager.request(apiModel: GetApi.infoDetailGet(token: token, id: id))
      .asObservable()
      .withUnretained(self)
      .flatMap { remoteAPI, data in
        return remoteAPI.decoder.decode(data: data, model: InfoData.self)
      }
      .share()
  }
  
  func bookmark(token: String, id: Int, category: Category) -> Completable {
    return networkManager.request(apiModel: PostApi.postBookmark(token: token, postId: id, postCategory: category))
      .asCompletable()
  }
  
  func unbookmark(token: String, id: Int, category: Category) -> Completable {
    return networkManager.request(apiModel: DeleteApi.deleteBookmark(token: token, postId: id, postCategory: category))
      .asCompletable()
  }

}
