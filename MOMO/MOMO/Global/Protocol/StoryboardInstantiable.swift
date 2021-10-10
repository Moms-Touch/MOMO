//
//  StoryboardInstantiable.swift
//  MOMO
//
//  Created by abc on 2021/10/10.
//

import UIKit

protocol StoryboardInstantiable: AnyObject {
  
  static func loadFromStoryboard() -> UIViewController
}

extension StoryboardInstantiable {
  
  /// 우리 팀은 Storyboard 의 작명규칙을
  /// ViewController 를 제외한 이름으로 정하기로 결정했다.
  static var fileName: String {
    
    let className = String(describing: self)
    
    // "ViewController".count is 14
    return String(className.prefix(className.count - 14))
  }
  
  static var storyboardIdentifier: String {
    
    return String(describing: self)
  }
  
  static func loadFromStoryboard() -> UIViewController {
    
    let storyboard = UIStoryboard(name: Self.fileName, bundle: nil)
    
    let homeMainVC = storyboard.instantiateViewController(identifier: Self.storyboardIdentifier)
    
    return homeMainVC
  }
}
