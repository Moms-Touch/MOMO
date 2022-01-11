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
    guard let token = UserManager.shared.token else {return}
    networkManager.request(apiModel: GetApi.bookmarkGet(token: token)) { (result) in
      switch result {
      case .success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: [BookmarkData].self) { [weak self]  (body) in
          guard let self = self else {return}
          bookmarkData = body
          // 잠시 정보만으로 변경
          let infoBookmark = bookmarkData.filter { $0.post.category == Category.info }
          let postData = infoBookmark.sorted { $0.createdAt < $1.createdAt }.map { return $0.post }
          
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
    tableView.sectionHeaderHeight = UITableView.automaticDimension
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
    cell.selectionStyle = .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return UITableView.automaticDimension
  }
 
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollView.bounces = scrollView.contentOffset.y > 0
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let infoId = datasource[indexPath.section].id
    guard let token = UserManager.shared.token else {return}
    networkManager.request(apiModel: GetApi.infoDetailGet(token: token, id: infoId)) { (result) in
      switch result {
      case .success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: InfoData.self) { (body) in
          DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            guard let vc = RecommendDetailViewController.loadFromStoryboard() as? RecommendDetailViewController else {return}
            vc.data = body
            vc.index = indexPath.section
            vc.deleteCompletionHandler = { index in
              self.datasource.remove(at: index)
              self.tableView.reloadData()
              return
            }
            self.present(vc, animated: true, completion: nil)
          }
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
}
