//
//  UIImageView+Extension.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import UIKit
import Kingfisher
import FirebaseStorage

// imageview.setImage(여기에 urlstring) 넣으면 캐싱하면서 없으면 storage에서 이미지다운로드
extension UIImageView {
  func setImage(with UrlString: String) {
    
    // 이미지가 default면 이미지 다운로드가 아닌 바로 로고를 사용한다.
    if UrlString == "default" {
      self.image = UIImage(named: "Logo")
      return
    }
    
    let cache = ImageCache.default
    guard let newUrlString = UrlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {return}
    let imageUrl  = "\(StorageService.shared.imageBaseUrl)\(newUrlString)"
    print("캐싱한것 찾을떄 쓰이는 url \(imageUrl)")
    cache.retrieveImage(forKey: imageUrl) { (result) in
      switch result {
      case .success(let value):
        if let image = value.image {
          print("캐시가 된것을 꺼내쓴다.")
          self.image = image
        } else {
          let storage = Storage.storage()
          storage.reference(forURL: imageUrl).downloadURL { (url, error) in
            if let error = error {
              print("ERROR \(error.localizedDescription)")
              self.image = UIImage(named: "Logo")
              return
            }
            guard let url = url else {
              return
            }
            print("이미지 캐시가 되지 않아서 다시 다운받는다.", url)
            let resource = ImageResource(downloadURL: url, cacheKey: imageUrl)
            self.kf.setImage(with: resource)
          }
        }
      case .failure(let error):
        print(error)
        self.image = UIImage(named: "Logo")
      }
    }
  }
}
