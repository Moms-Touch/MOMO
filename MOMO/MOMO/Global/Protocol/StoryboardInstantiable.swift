//
//  StoryboardInstantiable.swift
//  MOMO
//
//  Created by abc on 2021/10/10.
//

import UIKit

protocol StoryboardInstantiable: AnyObject {
  
  /*
   Name of Storyboard file.
   You can simply custom this property if error occurs with synthesized impelmentation.
   */
  
  static var storyboardName: String { get }
  
  /*
   Identifier of a ViewController in a Storyboard file
   */
  
  static var storyboardIdentifier: String { get }
  
  /*
   Returns an instance of ViewController from given identifier initiated with Storyboard UI Settings.
   */
  
  static func loadFromStoryboard() -> UIViewController
}

extension StoryboardInstantiable {

  static var storyboardName: String {
    
    let className = String(describing: self)
    
    let classNameWithoutVC = className.replacingOccurrences(of: "ViewController", with: "")
    
    let classNameWithoutTable = classNameWithoutVC.replacingOccurrences(of: "Table", with: "")
    
    return classNameWithoutTable
  }
  
  static var storyboardIdentifier: String {

    return String(describing: self)
  }
  
  static func loadFromStoryboard() -> UIViewController {
    
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    
    let viewControllerFromStoryboard = storyboard.instantiateViewController(identifier: storyboardIdentifier)
    
    return viewControllerFromStoryboard
  }
}
