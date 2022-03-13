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
  @IBOutlet weak var nicknameLabel: MyPageLabel! {
    didSet {
      nicknameLabel.text = UserManager.shared.userInfo?.nickname
    }
  }
  @IBOutlet weak var emailLabel: MyPageLabel! {
    didSet {
      emailLabel.text = UserManager.shared.userInfo?.email
    }
  }
  @IBOutlet weak var infoLabel: MyPageLabel! {
    didSet {
      let location: String = UserManager.shared.userInfo?.location ?? "대한민국"
      let babyBirth: String = UserManager.shared.babyInWeek ?? ""
      infoLabel.text = "\(location)에 사는 엄마"
    }
  }
  @IBOutlet weak var infoView: UIView!{
    didSet {
      infoView.setRound(20)
      infoView.layer.borderColor = Asset.Colors.pink4.color.cgColor
      infoView.layer.borderWidth = 1
    }
  }
  @IBOutlet var changeLabel: [MyPageLabel]!
  
  @IBOutlet weak var changeInfoView: UIView! {
    didSet {
      changeInfoView.setRound(20)
      changeInfoView.layer.borderColor = Asset.Colors.pink4.color.cgColor
      changeInfoView.layer.borderWidth = 1
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(changeInfo), name: UserManager.didSetAppUserNotification, object: nil)
    addGestureToChangeLabel()
  }
  
  //MARK: - private
  lazy var networkManager = NetworkManager()
  
  @objc private func didTapChangeLabel(_ sender: UITapGestureRecognizer) {
    switch sender.view {
    case changeLabel[0]:
      didTapChangeNickname()
    case changeLabel[1]:
      didTapChangeLocation()
    case changeLabel[2]:
      didTapChangeStatus()
    default:
      return
    }
  }
  
  private func setGesture() -> UITapGestureRecognizer {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeLabel(_:)))
    return tapGesture
  }
  
  @IBAction private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func changeInfo() {
    guard let userInfo = UserManager.shared.userInfo else {return}
    self.nicknameLabel.text = userInfo.nickname
    self.emailLabel.text = userInfo.email
    let location: String = userInfo.location
    let babyBirth: String = UserManager.shared.babyInWeek ?? "0주차"
    self.infoLabel.text = "\(location)에 사는 엄마"
  }
  
  private func addGestureToChangeLabel() {
    changeLabel.forEach {
      $0.isUserInteractionEnabled = true
      $0.addGestureRecognizer(setGesture())
    }
  }
  
  private func didTapChangeNickname() {
    guard let token = UserManager.shared.token else {return }
    guard let userInfo = UserManager.shared.userInfo else {return}
    let alertVC = UIAlertController(title: "닉네임 변경", message: nil, preferredStyle: .alert)
    alertVC.isAccessibilityElement = false
    alertVC.addTextField { $0.placeholder = "닉네임을 입력해주세요" }
    let cancel = UIAlertAction(title: "취소", style: .destructive) { action in
      return
    }
    let ok = UIAlertAction(title: "변경", style: .default) { action in
      guard let newNick = alertVC.textFields?[0].text else { return }
      self.networkManager.request(apiModel: PutApi.putUser(token: token, email: userInfo.email, nickname: newNick, isPregnant: userInfo.isPregnant, hasChild: userInfo.hasChild, age: userInfo.age, location: userInfo.location)) { (result) in
        switch result {
        case .success(let data):
          let parsingManager = NetworkCoder()
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
  }
  
  private func didTapChangeLocation() {
    guard let locationvc = LocationViewController.loadFromStoryboard() as? LocationViewController else {return}
    locationvc.editMode = true
    present(locationvc, animated: true, completion: nil)
  }
  
  private func didTapChangeStatus() {
    guard let token = UserManager.shared.token else {return }
    guard let userInfo = UserManager.shared.userInfo else {return}
    let alertVC = UIAlertController(title: "임신/출산 여부 변경", message: nil, preferredStyle: .actionSheet)
    alertVC.isAccessibilityElement = false
    let isPregnant = UIAlertAction(title: "임신 중", style: .default) { action in
      self.networkManager.request(apiModel: PutApi.putUser(token: token, email: userInfo.email, nickname: userInfo.nickname, isPregnant: true, hasChild: userInfo.hasChild, age: userInfo.age, location: userInfo.location)) { (result) in
        switch result {
        case .success(let data):
          let parsingManager = NetworkCoder()
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
      self.networkManager.request(apiModel: PutApi.putUser(token: token, email: userInfo.email, nickname: userInfo.nickname, isPregnant: false, hasChild: userInfo.hasChild, age: userInfo.age, location: userInfo.location)) { (result) in
        switch result {
        case .success(let data):
          let parsingManager = NetworkCoder()
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
