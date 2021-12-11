//
//  CommuntiyBookmarkTableViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/15.
//

import UIKit

final class CommuntiyBookmarkTableViewController: UITableViewController, StoryboardInstantiable, TableViewGappable {
  
  var headerHeight: CGFloat {
      return gapBWTCell
  }
  
  var footerHeight: CGFloat {
      return gapBWTCell
  }
  
  private var gapBWTCell:CGFloat = 10;
  private var datasource: [SimpleCommunityData] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(ListTableViewCell.self)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return datasource.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell

    //TODO: 데이터 넣어주기
    cell.getSimpleData(data: datasource[indexPath.section])

    return cell
  }
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollView.bounces = scrollView.contentOffset.y > 0
  }
  
  
  
}
