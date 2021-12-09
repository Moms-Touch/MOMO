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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 15.0, *) {
      tableView.sectionHeaderTopPadding = 0
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0: //infoEdit
      self.navigationController?.pushViewController(MyInfoEditViewController(), animated: true)
    case 1: //babyInfo
      self.navigationController?.pushViewController(MyBabyInfoViewController.loadFromStoryboard(), animated: true)
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
