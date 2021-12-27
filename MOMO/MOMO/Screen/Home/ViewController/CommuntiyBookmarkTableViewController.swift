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
  
  private var gapBWTCell:CGFloat = 10
  
  private var datasource: [Post] = []
  
  lazy var networkManager = NetworkManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(ListTableViewCell.self)
    getData()
  }
  
  private func getData() {
    
    var bookmarkData: [BookmarkData] = []
    
    networkManager.request(apiModel: GetApi.bookmarkGet(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzgsImlhdCI6MTY0MDUxMTA0OSwiZXhwIjoxNjQwNzcwMjQ5LCJpc3MiOiJtb21vIn0.Z52lgsVvt9deFR7E94rTVNgLEdl4DNWKZGxI8NlgB54")) { (result) in
      switch result {
      case .success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: [BookmarkData].self) { [weak self] (body) in
          guard let self = self else {return}
          bookmarkData = body
          let postData = bookmarkData.filter { $0.post.category == Category.community }.sorted { $0.createdAt < $1.createdAt }.map { return $0.post }
          if postData.count == self.datasource.count {
            return
          } else {
            self.datasource = postData
            DispatchQueue.main.async {
              self.tableView.reloadData()
            }
          }
        }
      case .failure(let error):
        print(error)
      }
    }
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
