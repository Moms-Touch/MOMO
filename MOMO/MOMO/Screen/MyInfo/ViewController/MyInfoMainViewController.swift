//
//  MyInfoMainViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit

class MyInfoMainViewController: UIViewController, StoryboardInstantiable {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func didTapBackButton(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
}

class MyInfoMainTableViewController: InfoBaseTableViewController {
  
  lazy var networkManager = NetworkManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 15.0, *) {
      tableView.sectionHeaderTopPadding = 0
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0: //infoEdit
      self.navigationController?.pushViewController(MyInfoEditViewController.loadFromStoryboard(), animated: true)
    case 1: //babyInfo
      guard let token = UserManager.shared.token else { return }
      networkManager.request(apiModel: GetApi.babyGet(token: token)) { (result) in
        switch result {
        case .success(let data):
          let parsingManager = ParsingManager()
          parsingManager.judgeGenericResponse(data: data, model: [BabyData].self) { [weak self] (body) in
            guard let self = self else {return}
            if body.count != 0 {
              let baby = body[0]
              print(baby)
              DispatchQueue.main.async {
                guard let babyInfoVC = MyBabyInfoViewController.loadFromStoryboard() as? MyBabyInfoViewController else {return}
                BabyInfo.babyImage(imageURL: baby.imageURL)
                BabyInfo.babyName(name: baby.name)
                self.navigationController?.pushViewController(babyInfoVC, animated: true)
              }
            }
          }
        case .failure(let error):
          print(error)
        }
      }
      
      
    case 2: //MyActivity
      self.navigationController?.pushViewController(MyActivityViewController.loadFromStoryboard(), animated: true)
    case 3: // MySetting
      self.navigationController?.pushViewController(MySettingViewController.loadFromStoryboard(), animated: true)
    case 4:
      print(#function)
    case 5:
      print(#function)
    default:
      return
    }
  }
  
  
}
