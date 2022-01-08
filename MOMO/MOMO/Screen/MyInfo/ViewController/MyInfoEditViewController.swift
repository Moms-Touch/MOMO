//
//  MyInfoEditViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/10.
//

import UIKit
import Toast

final class MyInfoEditViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var navTitle: UILabel! {
    didSet {
      navTitle.navTitleStyle()
    }
  }
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
      infoLabel.text = "\(location)에 사는 엄마"
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
    self.nicknameLabel.text = userInfo.nickname
    self.emailLabel.text = userInfo.email
    let location: String = userInfo.location
    let babyBirth: String = UserManager.shared.babyInWeek ?? "0주차"
    self.infoLabel.text = "\(location)에 사는 엄마"
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
    guard let token = UserManager.shared.token else {return }
    guard let userInfo = UserManager.shared.userInfo else {return}
    let networkManager = NetworkManager()
    
    switch cell {
    case .nickname:
      let alertVC = UIAlertController(title: "닉네임 변경", message: nil, preferredStyle: .alert)
      alertVC.isAccessibilityElement = false
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
              DispatchQueue.main.async {  [weak self] in
                self?.view.makeToast("\(newNick)으로 닉네임 변경되었습니다")
                UserManager.shared.userInfo = body
              }
            }
          case .failure:
            DispatchQueue.main.async { [weak self] in
              self?.view.makeToast("닉네임이 중복되었습니다.\n다른 닉네임으로 변경해주세요")
            }
          }
        }
      }
      alertVC.addAction(cancel)
      alertVC.addAction(ok)
      present(alertVC, animated: true, completion: nil)
    case .location:
      guard let locationvc = LocationViewController.loadFromStoryboard() as? LocationViewController else {return}
      locationvc.editMode = true
      present(locationvc, animated: true, completion: nil)
    case .currentStatus:
      let alertVC = UIAlertController(title: "임신/출산 여부 변경", message: nil, preferredStyle: .actionSheet)
      alertVC.isAccessibilityElement = false
      let isPregnant = UIAlertAction(title: "임신 중", style: .default) { action in
        networkManager.request(apiModel: PutApi.putUser(token: token, email: userInfo.email, nickname: userInfo.nickname, isPregnant: true, hasChild: userInfo.hasChild, age: userInfo.age, location: userInfo.location)) { (result) in
          switch result {
          case .success(let data):
            let parsingManager = ParsingManager()
            parsingManager.judgeGenericResponse(data: data, model: UserData.self) { [ weak self] (body) in
              DispatchQueue.main.async {
                self?.view.makeToast("임신중으로 변경되었습니다.")
                UserManager.shared.userInfo = body
              }
            }
          case .failure(_):
            DispatchQueue.main.async { [weak self] in
              self?.view.makeToast("변경 실패입니다. 다시 시도해주세요")
            }
          }
        }
      }
      let isNotPregnant = UIAlertAction(title: "출산 후", style: .default) { action in
        networkManager.request(apiModel: PutApi.putUser(token: token, email: userInfo.email, nickname: userInfo.nickname, isPregnant: false, hasChild: userInfo.hasChild, age: userInfo.age, location: userInfo.location)) { (result) in
          switch result {
          case .success(let data):
            let parsingManager = ParsingManager()
            parsingManager.judgeGenericResponse(data: data, model: UserData.self) { [weak self](body) in
              DispatchQueue.main.async {
                self?.view.makeToast("출산 후로 변경되었습니다.")
                UserManager.shared.userInfo = body
              }
            }
          case .failure(_):
            DispatchQueue.main.async { [weak self] in
              self?.view.makeToast("변경 실패입니다. 다시 시도해주세요")
            }
          }
        }
      }
      let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
        return
      }
      alertVC.addAction(isPregnant)
      alertVC.addAction(isNotPregnant)
      alertVC.addAction(cancel)
      self.present(alertVC, animated: true, completion: nil)
    }
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
    case location
    case currentStatus
  }
}




