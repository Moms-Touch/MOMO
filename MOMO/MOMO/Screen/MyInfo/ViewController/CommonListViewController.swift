//
//  CommonListViewController.swift
//  MOMO
//
//  Created by abc on 2021/12/30.
//

import UIKit

class CommonListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewGappable {

  var headerHeight: CGFloat {
    return gapBWTCell
  }
  
  @IBOutlet weak var navTitle: UILabel! {
    didSet {
      navTitle.navTitleStyle()
    }
  }
  
  var footerHeight: CGFloat {
    return gapBWTCell
  }
  @IBOutlet weak var tableview: UITableView!

  private var gapBWTCell:CGFloat = 10;
  var datasource: [SimpleCommunityData] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableview.dataSource = self
    tableview.delegate = self
    tableview.register(ListTableViewCell.self)
  }
  
  @IBAction func didtapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}

extension CommonListViewController: StoryboardInstantiable {
  func numberOfSections(in tableView: UITableView) -> Int {
    return datasource.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
    cell.getSimpleData(data: datasource[indexPath.section])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollView.bounces = scrollView.contentOffset.y > 0
  }
}
