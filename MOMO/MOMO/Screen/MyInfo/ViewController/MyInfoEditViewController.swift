//
//  MyInfoEditViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/10.
//

import UIKit

final class MyInfoEditViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var nicknameLabel: UILabel! {
    didSet {
      nicknameLabel.text = UserManager.shared.userInfo?.nickname
    }
  }
  @IBOutlet weak var emailLabel: UILabel! {
    didSet {
      emailLabel.text = UserManager.shared.userInfo?.email
    }
  }
  @IBOutlet weak var infoLabel: UILabel! {
    didSet {
      let location: String = UserManager.shared.userInfo?.location ?? "대한민국"
      let babyBirth: String = UserManager.shared.babyInWeek ?? ""
      infoLabel.text = "\(location)에 사는 \(babyBirth) 엄마"
    }
  }
  @IBOutlet weak var infoView: UIView! {
    didSet {
      infoView.setRound(20)
      infoView.layer.borderColor = Asset.Colors.pink4.color.cgColor
      infoView.layer.borderWidth = 1
    }
  }
  
  //TODO: userdata가 생기고 userData에서 변경사항 생기면 notificiation 전체 쏘는것으로 해서 여기 있는 데이터 변경
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(changeInfo), name: UserManager.didSetAppUserNotification, object: nil)
  }
  
  @objc func changeInfo() {
    guard let userInfo = UserManager.shared.userInfo else {return}
    print(userInfo)
    self.nicknameLabel.text = userInfo.nickname
    self.emailLabel.text = userInfo.email
    let location: String = userInfo.location
    let babyBirth: String = UserManager.shared.babyInWeek ?? ""
    self.infoLabel.text = "\(location)에 사는 \(babyBirth) 엄마"
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
}

final class EditInfoTableViewController: InfoBaseTableViewController {
  
  lazy var networkManager = NetworkManager()
  
  override func viewDidLoad() {
    tableView.setRound(20)
    tableView.layer.borderColor = Asset.Colors.pink4.color.cgColor
    tableView.layer.borderWidth = 1
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let cell = SettingTableName(rawValue: indexPath.row) else {return}
    guard let alertVC = cell.destination else {return}
    present(alertVC, animated: true, completion: nil)
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
    
    var destination: UIViewController? {
      let networkManager = NetworkManager()
      guard let token = UserManager.shared.token else {return nil}
      guard let userInfo = UserManager.shared.userInfo else {return nil}
      switch self {
      case .nickname:
        let alertVC = UIAlertController(title: "닉네임 변경", message: nil, preferredStyle: .alert)
        alertVC.addTextField { $0.placeholder = "닉네임을 입력해주세요" }
        let cancel = UIAlertAction(title: "취소", style: .destructive) { action in
          return
        }
        let ok = UIAlertAction(title: "변경", style: .default) { action in
          guard let newNick = alertVC.textFields?[0].text else { return }
          networkManager.request(apiModel: PutApi.putUser(token: token, email: userInfo.email, nickname: newNick, isPregnant: userInfo.isPregnant, hasChild: userInfo.hasChild, age: userInfo.age, location: userInfo.location)) { (result) in
            switch result {
            case .success(let data):
              let parsingManager = ParsingManager()
              parsingManager.judgeGenericResponse(data: data, model: UserData.self) { (body) in
                DispatchQueue.main.async {
                  UserManager.shared.userInfo = body
                }
              }
            case .failure(let error):
              print(error)
            }
          }
        }
        alertVC.addAction(cancel)
        alertVC.addAction(ok)
        return alertVC
      case .password:
        let alertVC = UIAlertController(title: "비밀번호 변경", message: nil, preferredStyle: .alert)
        alertVC.addTextField { $0.placeholder = "현재 비밀번호" }
        alertVC.addTextField { $0.placeholder = "새로운 비밀번호"}
        let cancel = UIAlertAction(title: "취소", style: .destructive) { action in
          return
        }
        let ok = UIAlertAction(title: "변경", style: .default) { action in
          guard let oldPassword = alertVC.textFields?[0].text else { return }
          guard let newPassword = alertVC.textFields?[1].text else { return }
          print(oldPassword)
          print(newPassword)
          // api 생기면 추가하기
        }
        alertVC.addAction(cancel)
        alertVC.addAction(ok)
        return alertVC
      case .location:
        guard let locationvc = LocationViewController.loadFromStoryboard() as? LocationViewController else {return nil}
        locationvc.editMode = true
        return locationvc
      case .currentStatus:
        guard let user = UserManager.shared.userInfo else {return nil}
        let alertVC = UIAlertController(title: "임신/출산 여부 변경", message: nil, preferredStyle: .actionSheet)
        let isPregnant = UIAlertAction(title: "임신 중", style: .default) { action in
          networkManager.request(apiModel: PutApi.putUser(token: token, email: userInfo.email, nickname: userInfo.nickname, isPregnant: true, hasChild: userInfo.hasChild, age: userInfo.age, location: userInfo.location)) { (result) in
            switch result {
            case .success(let data):
              let parsingManager = ParsingManager()
              parsingManager.judgeGenericResponse(data: data, model: UserData.self) { (body) in
                DispatchQueue.main.async {
                  UserManager.shared.userInfo = body
                }
              }
            case .failure(let error):
              print(error)
            }
          }
        }
        let isNotPregnant = UIAlertAction(title: "출산 후", style: .default) { action in
          networkManager.request(apiModel: PutApi.putUser(token: token, email: userInfo.email, nickname: userInfo.nickname, isPregnant: false, hasChild: userInfo.hasChild, age: userInfo.age, location: userInfo.location)) { (result) in
            switch result {
            case .success(let data):
              let parsingManager = ParsingManager()
              parsingManager.judgeGenericResponse(data: data, model: UserData.self) { (body) in
                DispatchQueue.main.async {
                  UserManager.shared.userInfo = body
                }
              }
            case .failure(let error):
              print(error)
            }
          }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
          return
        }
        alertVC.addAction(isPregnant)
        alertVC.addAction(isNotPregnant)
        alertVC.addAction(cancel)
        return alertVC
      }
    }
  }
}




