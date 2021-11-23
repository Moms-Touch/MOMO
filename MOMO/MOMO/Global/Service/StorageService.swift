//
//  StorageService.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import UIKit
import FirebaseStorage
import Kingfisher

class StorageService {
  
  static let shared = StorageService()
  private init() {}
  
  let storage = Storage.storage()
  let imageBaseUrl = "gs://momo-51df6.appspot.com/images/"
  
  // completion 없는 것
  func uploadImage(img: UIImage, imageName: String) {
    var data = Data()
    data = img.jpegData(compressionQuality: 0.1)!
    guard let filePath = imageName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {return}
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpeg"
    storage.reference().child("images/\(filePath)").putData(data, metadata: metaData){
      (metaData, error) in
      if let error = error {
        print(error.localizedDescription)
      } else {
        print("성공")
      }
    }
  }
  
  //completion 있는 것
  func uploadImage(img: UIImage, imageName: String,  completion: @escaping () -> Void) {
    var data = Data()
    data = img.jpegData(compressionQuality: 0.1)!
    guard let filePath = imageName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {return}
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpeg"
    storage.reference().child("images/\(filePath)").putData(data, metadata: metaData){
      (metaData, error) in
      if let error = error {
        print(error.localizedDescription)
      } else {
        print("성공")
        completion()
      }
    }
  }
  
  func uploadImageWithData(imageData: Data, imageName: String, completion: @escaping () -> Void) {
    guard let filePath = imageName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {return}
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpeg"
    storage.reference().child("images/\(filePath)").putData(imageData, metadata: metaData){
      (metaData, error) in
      if let error = error {
        print(error.localizedDescription)
      } else {
        print("성공")
        completion()
      }
    }
  }
  
  func downloadUIImageWithURL(with UrlString: String, imageCompletion: @escaping (UIImage?) -> Void) {
    guard let newURL = UrlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {return}
    let imageUrl = "\(imageBaseUrl)\(newURL)"
    storage.reference(forURL: imageUrl).downloadURL { (url, error) in
      if let error = error {
        print("ERROR \(error.localizedDescription)")
        return
      }
      guard let url = url else {
        return
      }
      let resource = ImageResource(downloadURL: url)
      Kingfisher.KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
        switch result{
        case .success(let value):
          imageCompletion(value.image)
        case .failure:
          imageCompletion(nil)
        }
      }
    }
  }
  
  func deleteImage(imageName: String){
    storage.reference().child("images").delete { (error) in
      if let error = error {
        print("지우는데 에러가 생겼다. \(error.localizedDescription)")
      } else {
        print("\(imageName)파일 지우는데 성공")
      }
    }
  }
}
