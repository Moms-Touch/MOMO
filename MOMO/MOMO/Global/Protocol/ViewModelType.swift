//
//  ViewModelType.swift
//  MOMO
//
//  Created by abc on 2022/03/12.
//

import Foundation

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  var input: Input { get }
  var output: Output { get }
}
