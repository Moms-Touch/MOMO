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
  
  private var datasource: [Post] = []
  
  lazy var networkManager = NetworkManager()
  
  private func getData() {
    var bookmarkData: [BookmarkData] = []
    // 1. 가져온다.
    networkManager.request(apiModel: GetApi.bookmarkGet(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzgsImlhdCI6MTY0MDUxMTA0OSwiZXhwIjoxNjQwNzcwMjQ5LCJpc3MiOiJtb21vIn0.Z52lgsVvt9deFR7E94rTVNgLEdl4DNWKZGxI8NlgB54")) { (result) in
      switch result {
      case .success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: [BookmarkData].self) { [weak self]  (body) in
          guard let self = self else {return}
          bookmarkData = body
          let policyBookmark = bookmarkData.filter { $0.post.category != Category.community }
          let postData = policyBookmark.sorted { $0.createdAt < $1.createdAt }.map { return $0.post }
          
          // 현재 갯수와 동일한지 확인, 동일하다면 -> 버린다.
          if postData.count == self.datasource.count {
            return
          } else { // 다르다면 전체 동기화
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(ListTableViewCell.self)
    getData()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
//    return 10
    return datasource.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 1
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell

    //TODO: data 넣어주기
    //section으로 어레이 참조하기
    cell.getSimpleData(data: datasource[indexPath.section])

    return cell
  }
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollView.bounces = scrollView.contentOffset.y > 0
  }
  
}
