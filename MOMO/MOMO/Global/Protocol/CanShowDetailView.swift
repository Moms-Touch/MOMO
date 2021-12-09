//
//  CanShowMyInfoVC.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import UIKit

// 하나의 detailView를 차용한다면, 이 protocol을 사용할 수 있다.
// 아무래도 tableview vc, vc -> detail 

protocol CanShowDetailView: AnyObject {
  func showDetailView(content: Any?)
  var navigationController: UINavigationController {get}
    // Any는 나중에 Model로 변경한다.
    // Model은 특정 protocol을 받아야할 것이다.
}

extension CanShowDetailView {
  func showDetailView(content: Any?) {
    let detailViewController = DetailViewController()
    detailViewController.content = content
    self.navigationController.pushViewController(detailViewController, animated: true)
  }
}


