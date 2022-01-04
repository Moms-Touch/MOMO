//
//  SignUpViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/10/30.
//

import UIKit
import Security
import CryptoKit
import Toast

final class SignUpViewController: UIViewController {
  
  @IBOutlet private weak var explanationLabel: UILabel!
  @IBOutlet private weak var emailTextField: MomoBaseTextField!
  @IBOutlet private weak var passwordTextField: MomoBaseTextField!
  @IBOutlet weak var nicknameTextField: MomoBaseTextField!
  @IBOutlet private weak var nextButton: UIButton! {
    didSet {
      nextButton.momoButtonStyle()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpView()
    hideKeyboard()
  }
  
  private func setUpView() {
    emailTextField.setBorderColor(to: Asset.Colors.pink2.color)
    passwordTextField.setBorderColor(to: Asset.Colors.pink2.color)
    nicknameTextField.setBorderColor(to: Asset.Colors.pink2.color)
    emailTextField.addLeftPadding(width: 10)
    passwordTextField.addLeftPadding(width: 10)
    nicknameTextField.addLeftPadding(width: 10)
  }
  
  @IBAction func didTapNextbutton(_ sender: UIButton) {
    guard let locationVC = LocationViewController.loadFromStoryboard() as? LocationViewController else {
      print("locationVC empty")
      return
    }
    guard doubleCheck() else {
      return
    }
    locationVC.email = emailTextField.text ?? ""
    locationVC.password = passwordTextField.text ?? ""
    locationVC.nickname = nicknameTextField.text ?? ""
    
    navigationController?.pushViewController(locationVC, animated: true)
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func didTapDoubleCheck(_ sender: UIButton) {
    guard let nickname = nicknameTextField.text else {
      self.view.makeToast("닉네임을 입력안했습니다.")
      return
    }
    let networkManager = NetworkManager()
    networkManager.request(apiModel: GetApi.nicknameGet(nickname: nickname)) { [weak self] result in
      switch result {
      case .success:
        DispatchQueue.main.async {
          self?.nextButton.alpha = 1
          self?.nextButton.isUserInteractionEnabled = true
        }
      case .failure:
        self?.view.makeToast("닉네임이 중복되었습니다 다시 입력해주세요.")
      }
    }
  }
  
  @IBAction func didchangeTextfieldValue(_ sender: UITextField) {
    if doubleCheck() {
      nextButton.isUserInteractionEnabled = true
      nextButton.alpha = 1
    }
  }
}

extension SignUpViewController: StoryboardInstantiable { }

extension SignUpViewController {
  
  func doubleCheck() -> Bool {
    // 이메일 체크
    guard let email = emailTextField.text else {
      self.view.makeToast("이메일 확인바랍니다.")
      return false}
    guard isValidEmail(email) else {
      self.view.makeToast("이메일 확인바랍니다.")
      return false}
    
    //비밀번호 체크
    guard let password = passwordTextField.text else {
      self.view.makeToast("비밀번호를 확인해주세요")
      return false
    }
    
    guard isValidPassword(password: password) else {
      self.view.makeToast("비밀번호를 규칙을 확인해주세요")
      return false
    }
    
    // 닉네임 체크
    guard let nickname = nicknameTextField.text else {
      self.view.makeToast("닉네임을 입력안했습니다.")
      return false
    }
    
    return true
  }
  
  private func isValidEmail(_ address: String) -> Bool {
    let emailRex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRex)
    return emailCheck.evaluate(with: address)
  }
  
  func isValidPassword(password: String) -> Bool {
    //password 유효성 확인 정규식
    let passwordreg = ("(?=.*[A-Za-z])(?=.*[0-9]).{8,20}")
    let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
    return passwordtesting.evaluate(with: password)
  }
  
  func StringToSha256(string: String) -> String {
    let plainData: Data = string.data(using: .utf8)!
    let shaData = SHA256.hash(data: plainData)
    let shaString = shaData.compactMap {String(format: "%02x", $0)}.joined()
    return shaString
  }
  
  
}
