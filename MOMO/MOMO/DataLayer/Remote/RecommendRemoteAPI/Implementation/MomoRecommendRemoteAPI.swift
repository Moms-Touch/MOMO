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
  /**
   미혼모가 아이를 베고 있는 기한에 따라서 추천정보를 주기위한 API. 다량의 정보를 제공함, 정보 제공 collectionView에 진입할때 필요.
   - Parameters:
     - token: Token
     - start: 미혼모 아이가 몇주차인지의 처음
     - end: 미혼모 아이가 몇주차인지의 마지막
    - Returns: Observable<[InfoData]> InfoData 구조체의 배열
   */
  func fetch(token: String, start: Int, end: Int) -> Observable<[InfoData]> {
    return networkManager.request(apiModel: GetApi.infoGet(token: token, start: "\(start)", end: "\(end)"))
      .asObservable()
      .withUnretained(self)
      .flatMap { remoteAPI, data in
        return remoteAPI.decoder.decode(data: data, model: [InfoData].self)
      }
      .share()
  }
  
  /**
   미혼모에게 필요한 특정 한가지 정보만을 제공하는 API, 정보제공화면에서 쓰임.
   - Parameters token: 토큰
   - Parameters id: 정보의 id
   - Returns: Observable<InfoData>
   */
  func fetch(token: String, id: Int) -> Observable<InfoData> {
    return networkManager.request(apiModel: GetApi.infoDetailGet(token: token, id: id))
      .asObservable()
      .withUnretained(self)
      .flatMap { remoteAPI, data in
        return remoteAPI.decoder.decode(data: data, model: InfoData.self)
      }
      .share()
  }
  
    /**
     정보의 bookmark를 하는 API. 이 API는 정책정보와 추천정보 모두에서 쓰이는 API이다. 따라서 마지막 parameter의 카테고리에 따라서 어떤 정보에 북마크하는지 달라진다.
     - Parameters:
        - token: 토큰
        - id: 추천정보의 id
        - category: 정보의 카테고리 category에 info는 추천정보, policy는 정책정보, community는 커뮤니티 정보이다.
     - Returns: Completable
     */
  func bookmark(token: String, id: Int, category: Category) -> Completable {
    return networkManager.request(apiModel: PostApi.postBookmark(token: token, postId: id, postCategory: category))
      .asCompletable()
  }
  
    
    /**
     정보의 bookmark를 해제하는 API. 이 API는 정책정보와 추천정보 모두에서 쓰이는 API이다. 따라서 마지막 parameter의 카테고리에 따라서 어떤 정보의 북마크를 해제하는지 달려있다.
     - Parameters:
        - token: 토큰
        - id: 추천정보의 id
        - category: 정보의 카테고리 category에 info는 추천정보, policy는 정책정보, community는 커뮤니티 정보이다.
     - Returns: Completable
     */
  func unbookmark(token: String, id: Int, category: Category) -> Completable {
    return networkManager.request(apiModel: DeleteApi.deleteBookmark(token: token, postId: id, postCategory: category))
      .asCompletable()
  }

}
