//
//  PregnantStatusViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/11/14.
//

import UIKit
import SwiftUI

final class PregnantStatusViewController: UIViewController, KeyboardScrollable {
  @IBOutlet weak var pregnantVCScrollview: UIScrollView!
  @IBOutlet weak var explanationLabel: UILabel! {
    didSet {
      explanationLabel.font = UIFont.customFont(forTextStyle: .largeTitle)
    }
  }
  @IBOutlet weak var subExplanationLabel: UILabel! {
    didSet {
      subExplanationLabel.font = UIFont.customFont(forTextStyle: .callout)
    }
  }
  @IBOutlet private weak var nextButton: UIButton!
  @IBOutlet private weak var expectedBirthdayField: UITextField! {
    didSet {
      expectedBirthdayField.inputView = calenderDatePicker
      expectedBirthdayField.setUpFontStyle()
    }
  }
  @IBOutlet private weak var babyNameTextField: UITextField! {
    didSet {
      babyNameTextField.setUpFontStyle()
    }
  }
  @IBOutlet private weak var pregnantButton: UIButton!
  @IBOutlet private weak var birthButton: UIButton!
  @IBOutlet var constraint: [NSLayoutConstraint]!
  
  private var isOnPregnantButton = false
  private var isOnBirthButton = false
  private var checkPregnant = true
  private var age = 0
  
  private let formatter = DateFormatter()
  private var calenderDatePicker = UIDatePicker()
  private var networkManager = NetworkManager()
  private var expectedDate: String? = nil
  private var flag = false

  var email: String = ""
  var password: String = ""
  var nickname: String = ""
  var location = ""
  var scrollView: UIScrollView {
    return pregnantVCScrollview
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    expectedBirthdayField.setBottomBorder()
    babyNameTextField.setBottomBorder()
    hideKeyboard()
    configureDatePicker()
    setUpButtonUI()
    scrollingKeyboard()
  }
  
  override func viewWillLayoutSubviews() {
    if !flag {
      constraint.forEach { $0.constant = $0.constant.fit(self)}
      flag = true
    }
  }
  
  @IBAction func tappedPregnantButton() {
    isOnPregnantButton = true
    isOnBirthButton = false
    checkPregnant = true
    changeButtonStyle()
  }
  
  @IBAction func tappedBirthButton() {
    isOnPregnantButton = false
    isOnBirthButton = true
    checkPregnant = false
    changeButtonStyle()
  }
  
  //data 전달방식 실패 && token값 받아오는 방법 모름
  @IBAction func tappedMomoStartButton(_ sender: UIButton) {
    var babybirthday: String = ""
    //babyname
    //birth가 필요
    guard let babyname = babyNameTextField.text else {
      self.view.makeToast("태명/이름을 입력해주세요, 없다면 간단하게 적어주세요")
      return
    }
    
    if let babybirth = expectedBirthdayField.text {
        babybirthday = babybirth
    } else {
      self.view.makeToast("태어날 날짜를 모르신다면, 현재부터 6개월 뒤로 잡을게요👶")
      babybirthday = (Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date()).toString()
    }
    
    networkManager.request(apiModel: PostApi.registProfile(email: email, password: password, nickname: nickname, isPregnant: checkPregnant, hasChild: true, age: 0, location: location, babyName: babyname, babyBirth: babybirthday,  contentType: .jsonData)) { data in
      switch data {
      case .success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: LoginData.self) { [weak self] body in
          let newAccessToken = body.accesstoken
          let userId = body.id
          if KeyChainService.shared.loadFromKeychain(account: "accessToken") != nil {
            KeyChainService.shared.deleteFromKeyChain(account: "accessToken")
          }
          KeyChainService.shared.saveInKeychain(account: "accessToken", value: newAccessToken)
          UserManager.shared.userId = userId
          UserManager.shared.token = newAccessToken
          self?.networkManager.request(apiModel: GetApi.userGet(token: newAccessToken)) { result in
            switch result {
            case .success(let data):
              parsingManager.judgeGenericResponse(data: data, model: UserData.self) { user in
                DispatchQueue.main.async { [weak self] in
                    UserManager.shared.userInfo = user
                    print(user)
                  self?.moveToHomeMainView()
                }
              }
            case .failure(_):
              DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.view.makeToast("네트워크 오류입니다.")
              }
            }
          }
        }
      case .failure:
        DispatchQueue.main.async { [weak self] in
          guard let self = self else {return}
          guard let viewcontrollers: [UIViewController] = self.navigationController?.viewControllers else {return}
          self.navigationController?.popToViewController(viewcontrollers[viewcontrollers.count - 3], animated: false, completion: {
            viewcontrollers[viewcontrollers.count - 3].view.makeToast("다른 닉네임 혹은 다른 이메일로 다시 설정해주세요")
          })
        }
      }
    }
  }
  
  @IBAction func tappedBackButton(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
  private func checkAge(date: Date) -> Int{
    formatter.dateFormat = "YYYY"
    guard let birthYear = Int(formatter.string(from: date)) else {
      print("birthYear is not int")
      return -1
    }
    guard let currentYear = Int(formatter.string(from: Date())) else {
      print("currentYear is not int")
      return -1
    }
    return currentYear - birthYear + 1
  }
  
  private func setUpButtonUI() {
    nextButton.momoButtonStyle()
  }
  
  private func moveToHomeMainView() {
    DispatchQueue.main.async {
      //navigationbar없애야함.
      let home = TabBar()
      let newNaviController = UINavigationController(rootViewController: home)
      newNaviController.isNavigationBarHidden = true
      let sceneDelegate = UIApplication.shared.connectedScenes
              .first!.delegate as! SceneDelegate
      sceneDelegate.window!.rootViewController = newNaviController
    }
  }
  
  private func changeButtonStyle() {
    if isOnPregnantButton {
      pregnantButton.isSelected = true
      birthButton.isSelected = false
    } else if isOnBirthButton {
      pregnantButton.isSelected = false
      birthButton.isSelected = true
    }
  }
}

extension UITextField {
  func setBottomBorder() {
    self.layer.shadowColor = Asset.Colors.pink1.color.cgColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
  }
}

extension PregnantStatusViewController: StoryboardInstantiable {}

extension PregnantStatusViewController {
  
  private func addToolbar() {
    let toolbar = UIToolbar()
    toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
    toolbar.barTintColor = .white
    self.expectedBirthdayField.inputAccessoryView = toolbar
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    let done = UIBarButtonItem()
    done.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Asset.Colors.pink1.color], for: .normal)
    done.title = "완료"
    done.target = self
    done.action = #selector(datePickerDismiss)
    
    toolbar.setItems([flexSpace, done], animated: true)
  }
  
  private func configureDatePicker() {
    addToolbar()
    setAttributes()
  }
  
  private func setAttributes() {
    if #available(iOS 13.4, *) {
      calenderDatePicker.preferredDatePickerStyle = .wheels
    }
    calenderDatePicker.backgroundColor = .white
    calenderDatePicker.datePickerMode = .date
    calenderDatePicker.locale = Locale(identifier: "ko-KR")
    calenderDatePicker.timeZone = .autoupdatingCurrent
    calenderDatePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
  }
  
  @objc func datePickerDismiss() {
    self.view.endEditing(true)
  }
  
  @objc func handleDatePicker(_ sender: UIDatePicker) {
    self.expectedBirthdayField.text = sender.date.toString()
  }
}

extension PregnantStatusViewController: UITextFieldDelegate {
//  expectedBirthdayField
//  babyNameTextField
  private func setTextFieldDelegate() {
    babyNameTextField.delegate = self
    expectedBirthdayField.delegate = self
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == babyNameTextField {
      textField.resignFirstResponder()
    }
    return true
  }
  
}
