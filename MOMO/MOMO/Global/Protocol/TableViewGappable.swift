//
//  Gappable.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import Foundation
import UIKit

protocol TableViewGappable: AnyObject  {
  var headerHeight: CGFloat {get}
  var footerHeight: CGFloat {get}
}

extension TableViewGappable where Self: UITableViewController {
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: headerHeight))
    footerView.backgroundColor = .white
     return footerView
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: footerHeight))
    headerView.backgroundColor = .white
     return headerView
  }
}
