//
//  InfoBaseTableViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/13.
//

import UIKit

class InfoBaseTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 15.0, *) {
      tableView.sectionHeaderTopPadding = 0
    }
    tableView.alwaysBounceVertical = false
    tableView.alwaysBounceHorizontal = false
    tableView.bounces = false
    tableView.showsHorizontalScrollIndicator = false
    tableView.showsVerticalScrollIndicator = false
  }
  
  
}
