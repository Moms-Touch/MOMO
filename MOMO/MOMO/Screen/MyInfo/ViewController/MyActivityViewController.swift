//
//  MyActivityViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/10.
//

import UIKit

class MyActivityViewController: UIViewController,StoryboardInstantiable {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  @IBAction func didTabBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
}

class MyActivityTableViewController: InfoBaseTableViewController {
  
  lazy var networkManager = NetworkManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 15.0, *) {
      tableView.sectionHeaderTopPadding = 0
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0: //LikeList
      guard let token = UserManager.shared.token else {return}
      networkManager.request(apiModel: GetApi.likeGet(token: token)) { (result) in
        switch result {
        case .success(let data):
          let parsingManager = ParsingManager()
          parsingManager.judgeGenericResponse(data: data, model: [LikeData].self) { [weak self] (body) in
            guard let self = self else {return}
            let simpleCommunityData = body.compactMap { $0.community }
            let datasource = simpleCommunityData.filter {$0.isValid == true && $0.isDeleted == false }
            DispatchQueue.main.async {
              guard let vc = CommonListViewController.loadFromStoryboard() as? CommonListViewController else {return}
              vc.datasource = datasource
              print(datasource)
              self.navigationController?.pushViewController(vc, animated: true)
            }
          }
        case .failure(let error):
          print(error)
        }
      }
    case 1:
      let vc = BookmarkListViewController.loadFromStoryboard() as! BookmarkListViewController
      vc.mode = false
      self.navigationController?.pushViewController(vc, animated: true)
    default:
      return
    }
  }
  
}
