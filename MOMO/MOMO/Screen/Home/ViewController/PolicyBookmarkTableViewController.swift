//
//  PolicyBookmarkTableViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/15.
//

import UIKit

final class PolicyBookmarkTableViewController: UITableViewController, StoryboardInstantiable, TableViewGappable {
  
  var headerHeight: CGFloat {
      return gapBWTCell
  }
  
  var footerHeight: CGFloat {
      return gapBWTCell
  }
  
  private var gapBWTCell:CGFloat = 10;
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(ListTableViewCell.self)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 10
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 1
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell

    //TODO: data 넣어주기
    //section으로 어레이 참조하기

    return cell
  }
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollView.bounces = scrollView.contentOffset.y > 0
  }
  
}
