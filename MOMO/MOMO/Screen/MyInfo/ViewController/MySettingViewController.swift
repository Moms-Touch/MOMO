//
//  MySettingViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/10.
//

import UIKit

class MySettingViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var navTitle: UILabel! {
    didSet {
      navTitle.navTitleStyle()
    }
  }
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
}

class MySettingTableViewController: InfoBaseTableViewController {
  
  private var version: String? {
      guard let dictionary = Bundle.main.infoDictionary,
          let version = dictionary["CFBundleShortVersionString"] as? String,
          let build = dictionary["CFBundleVersion"] as? String else {return nil}
      
      let versionStr: String = "v.\(version)"
      return versionStr
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let senderInfo = sender as? (url: URL, title: String) else {return}
    guard let destinationVC = segue.destination as? SettingWebViewController else {return}
    destinationVC.targetURL = senderInfo.url
    destinationVC.title = senderInfo.title
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let cellType = SettingTableName(rawValue: indexPath.row) else {return}
    
    let name = cellType.description
    
    switch cellType {
    case .termsAndConditions: //이용약관
      let targetURL = URL(string: "https://momo-official.tistory.com/30")
      performSegue(withIdentifier: SettingWebViewController.identifier, sender: (targetURL, name))
    case .privacyPolicy: //개인정보 처리방침
      let targetURL = URL(string: "https://momo-official.tistory.com/29")
      performSegue(withIdentifier: SettingWebViewController.identifier, sender: (targetURL, name))
    case .openSourceLicense: //오픈소스 라이센스
      let targetURL = URL(string: "https://momo-official.tistory.com/46")
      performSegue(withIdentifier: SettingWebViewController.identifier, sender: (targetURL, name))
//    case .alarmSetting: // 알림설정
//      print("알림설정")
    case .versionInfo:
      print(name)
    }
  }
  
}

extension MySettingTableViewController {
  enum SettingTableName: Int, CaseIterable {
    case termsAndConditions
    case privacyPolicy
    case openSourceLicense
//    case alarmSetting
    case versionInfo
    
    var description: String {
      switch self {
      case .termsAndConditions :
        return "이용약관"
      case .privacyPolicy:
        return "개인정보 취급방침"
      case .openSourceLicense:
        return "오픈소스 라이센스"
//      case .alarmSetting:
//        return "알림설정"
      case .versionInfo:
        return "\(version)"
      }
    }
    
  }
}


