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

  func readUserSession() -> Observable<UserSession> {
    
  }
  
  
  func deleteUser() -> Completable {
    <#code#>
  }
  
  func updateUserInfo(with info: UserData) -> Observable<UserData> {
    <#code#>
  }
  
  func updatePassword(from old: String, with new: String) -> Completable {
    <#code#>
  }
  
  

  
}
