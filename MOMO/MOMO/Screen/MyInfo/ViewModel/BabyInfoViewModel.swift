//
//  BabyInfoViewModel.swift
//  MOMO
//
//  Created by abc on 2021/12/29.
//

import Foundation

class BabyInfoViewModel {
  
  var model: BabyData? {
    didSet {
      guard let completionHandler = completionHandler else {return}
      completionHandler()
    }
  }
  
  var completionHandler: (() -> Void)?
  
  var babyId: Int {
    return model?.id ?? -1
  }
  
  var babyImageUrl: String {
    return model?.imageUrl ?? "default"
  }
  
  var babyName: String {
    if let name = model?.name {
      if name == "" {
        return "아기이름"
      } else {
        return name
      }
    } else {
      return "아기이름"
    }
  }
  
  var placeholders = ["아기이름", "출생일/출생예정일"]
  
  var babyBirth: String {
    if let birth = model?.birthday {
      print(birth)
      return birth.trimStringDate()
    } else {
      return ""
    }
  }
  
  deinit {
    print(#function, self)
  }
  
  func updateBaby(token: String, name: String, birthday: String?, imageUrl: String?) {
    let networkManager = NetworkManager()
    networkManager.request(apiModel: PutApi.putBaby(token: token, id: babyId, name: name, birthday: birthday, imageUrl: imageUrl)) {  [weak self] (result) in
      guard let self = self else {return}
      switch result {
      case .success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: BabyData.self) { (body) in
          DispatchQueue.main.async {
            let baby = body
            self.model = baby
          }
        }
      case .failure(let error):
          print(error)
      }
    }
  }
  
  func createBaby(token: String, name: String, birthday: String?, imageUrl: String?) {
    let networkManager = NetworkManager()
    networkManager.request(apiModel: PostApi.postBaby(token: token, name: name, birth: birthday, imageUrl: imageUrl))
    {  [weak self] (result) in
      guard let self = self else {return}
      switch result {
      case .success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: BabyData.self) { (body) in
          DispatchQueue.main.async {
            let baby = body
            self.model = baby
          }
        }
      case .failure(let error):
          print(error)
      }
    }
  }
}
