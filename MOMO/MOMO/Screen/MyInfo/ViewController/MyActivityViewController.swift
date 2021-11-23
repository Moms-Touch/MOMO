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
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 15.0, *) {
      tableView.sectionHeaderTopPadding = 0
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0: //MyPost
      print("gotoMyPost")
    case 1: //MyComment
      print("gotoMyComment")
    case 2: //LikeList
      print("gotoLikeList")
    case 3: // BookMarkList
      print("gotoBookMarkList")
    default:
      return
    }
  }
  
}
