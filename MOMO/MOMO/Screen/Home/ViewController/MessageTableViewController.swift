//
//  MessageTableViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/29.
//

import UIKit

class MessageTableViewController: UITableViewController {
  
  override init(style: UITableView.Style) {
    super.init(style: .grouped)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var dataSource = [SimpleAlertModel](repeating: SimpleAlertModel(title: "도레미", alertType: .message
                                                                          , content: "하이하이"), count: 6)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    tableView.register(AlertTableViewCell.self)
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
  }

  
}

extension MessageTableViewController: TableViewGappable, CanShowDetailView {
  
  override var navigationController: UINavigationController {
    self.navigationController
  }
  
  var headerHeight: CGFloat {
    8
  }
  
  var footerHeight: CGFloat {
    8
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.identifier, for: indexPath) as?
            AlertTableViewCell else {return AlertTableViewCell()}
    cell.data = dataSource[indexPath.section]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    showDetailView(content: dataSource[indexPath.section])
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollView.bounces = scrollView.contentOffset.y > 0
  }
}
