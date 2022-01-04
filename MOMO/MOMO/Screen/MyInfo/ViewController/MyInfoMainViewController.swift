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
  
  @IBOutlet weak var loginLabel: UILabel! {
    didSet {
      if let token = UserManager.shared.token {
        loginLabel.text = "로그아웃"
      } else {
        loginLabel.text == "로그인"
      }
    }
  }
  
  
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
            if body.count > 0 {
              let baby = body[0]
              DispatchQueue.main.async {
                guard let babyInfoVC = MyBabyInfoViewController.loadFromStoryboard() as? MyBabyInfoViewController else {return}
                babyInfoVC.babyViewModel = BabyInfoViewModel()
                babyInfoVC.babyViewModel?.model = baby
                print(baby)
                self.navigationController?.pushViewController(babyInfoVC, animated: true)
              }
            } else  {
              DispatchQueue.main.async {
                guard let babyInfoVC = MyBabyInfoViewController.loadFromStoryboard() as? MyBabyInfoViewController else {return}
                babyInfoVC.babyViewModel = BabyInfoViewModel()
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
    case 4: //로그인 로그아웃
      if loginLabel.text == "로그아웃" {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃을 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .default, handler: {
          [weak self] (action) in
//          UserManager.shared.deleteUser()
          guard let loginVC = LoginViewController.loadFromStoryboard() as? LoginViewController else {return}
          let newNaviController = UINavigationController(rootViewController: loginVC)
          newNaviController.isNavigationBarHidden = true
          let sceneDelegate = UIApplication.shared.connectedScenes
                  .first!.delegate as! SceneDelegate
          sceneDelegate.window!.rootViewController = newNaviController
        }))
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
        self.present(alert, animated: true, completion: nil)
      } else {
        guard let loginVC = LoginViewController.loadFromStoryboard() as? LoginViewController else {return}
        let newNaviController = UINavigationController(rootViewController: loginVC)
        newNaviController.isNavigationBarHidden = true
        let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = newNaviController
      }
    case 5:
      let alert = UIAlertController(title: "회원탈퇴", message: "회원탈퇴하시겠습니까?", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "네", style: .default, handler: {
        (action) in
        guard let token = UserManager.shared.token else {return}
        self.networkManager.request(apiModel: DeleteApi.deleteUser(token: token)) { (result) in
          switch result {
          case .success(let data):
              DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                UserManager.shared.deleteUser()
                guard let loginVC = LoginViewController.loadFromStoryboard() as? LoginViewController else {return}
                let newNaviController = UINavigationController(rootViewController: loginVC)
                newNaviController.isNavigationBarHidden = true
                let sceneDelegate = UIApplication.shared.connectedScenes
                        .first!.delegate as! SceneDelegate
                sceneDelegate.window!.rootViewController = newNaviController
              }
          case .failure(let error):
            self.view.makeToast("회원탈퇴에 실패했어요. 다시 시도해주세요")
          }
        }}))
      alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
      self.present(alert, animated: true, completion: nil)
    default:
      return
    }
  }
  
  
}
