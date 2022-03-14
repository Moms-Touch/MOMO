//
//  MomoUserRemoteAPI.swift
//  MOMO
//
//  Created by abc on 2022/03/13.
//

import Foundation
import RxSwift

final class MomoUserRemoteAPI: UserRemoteAPI {
  
  //MARK: - Private Properties
  private let networkManager: NetworkProtocol
  private let decoder: NetworkDecoding
  
  //MARK: - init
  public init(networkManager: NetworkProtocol, decoder: NetworkDecoding) {
    self.networkManager = networkManager
    self.decoder = decoder
  }
  
  //MARK: - Methods
  
  func deleteUser(token: Token) -> Completable {
    return networkManager.request(apiModel: DeleteApi.deleteUser(token: token))
      .asCompletable()
  }
  
  func updateUserInfo(with info: UserData, token: Token) -> Observable<UserData> {
    return networkManager.request(apiModel: PutApi.putUser(token: token, email: info.email , nickname: info.nickname, isPregnant: info.isPregnant, hasChild: info.hasChild, age: info.age, location: info.location))
      .asObservable()
      .flatMap { [weak self] data -> Observable<UserData> in
        guard let self = self else {return Observable.error(CodingError.decodingError)}
        return self.decoder.decode(data: data, model: UserData.self)
      }
  }
  
  // cloud API not yet
  @available(*, deprecated)
  func updatePassword(from old: String, with new: String, token: Token) -> Completable {
    return Completable.create { complete in
      complete(.completed) as! Disposable
    }
  }

}
