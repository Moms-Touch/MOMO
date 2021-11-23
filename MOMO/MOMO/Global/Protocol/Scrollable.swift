//
//  Scrollable.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import UIKit

protocol Scrollable where Self: UIViewController {
  var scrollView: UIScrollView {get}
}
