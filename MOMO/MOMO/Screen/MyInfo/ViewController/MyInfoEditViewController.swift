//
//  MyInfoEditViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/10.
//

import UIKit

final class MyInfoEditViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var nicknameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var infoView: UIView! {
    didSet {
      infoView.setRound(20)
      infoView.layer.borderColor = Asset.Colors.pink4.color.cgColor
      infoView.layer.borderWidth = 1
    }
  }
  
  var userdata: [String] = []
  
  //TODO: userdata가 생기고 userData에서 변경사항 생기면 notificiation 전체 쏘는것으로 해서 여기 있는 데이터 변경
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
}

final class EditInfoTableViewController: InfoBaseTableViewController {
  
  override func viewDidLoad() {
    tableView.setRound(20)
    tableView.layer.borderColor = Asset.Colors.pink4.color.cgColor
    tableView.layer.borderWidth = 1
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    guard let cell = SettingTableName(rawValue: indexPath.row) else {return}
    print(cell)
    let destination = cell.destination
    
    //TODO: destination으로 정보 한번에 넘길 수 있도록 protocol 채택
    //TODO: 넘겨주는거로 해서 그냥 일괄처리 필요
    
    self.navigationController?.pushViewController(destination, animated: true)

  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView(frame: CGRect.zero)
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView(frame: CGRect.zero)
  }
}

extension EditInfoTableViewController {
  enum SettingTableName: Int, CaseIterable {
    case nickname
    case password
    case location
    case currentStatus
    
    var destination: UIViewController {
      switch self {
      case .nickname:
        return MyActivityViewController.loadFromStoryboard()
      case .password:
        return MyActivityViewController.loadFromStoryboard()
      case .location:
        return MyActivityViewController.loadFromStoryboard()
      case .currentStatus:
        return MyActivityViewController.loadFromStoryboard()
      }
    }
  }
}




