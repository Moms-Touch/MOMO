//
//  PregnantStatusViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/11/14.
//

import UIKit

final class PregnantStatusViewController: UIViewController {
  @IBOutlet private weak var nextButton: UIButton!
  @IBOutlet private weak var expectedBirthdayField: UITextField!
  @IBOutlet private weak var babyNameTextField: UITextField!
  @IBOutlet private weak var pregnantButton: UIButton!
  @IBOutlet private weak var birthButton: UIButton!
  @IBOutlet weak var calenderDatePicker: UIDatePicker! {
    didSet {
      calenderDatePicker.setValue(UIColor.white, forKey: "backgroundColor")
    }
  }
  @IBOutlet weak var toolbar: UIToolbar!
  
  private var isOnPregnantButton = false
  private var isOnBirthButton = false
  private var checkPregnant = true
  private var age = 0
  
  private let formatter = DateFormatter()
  private var networkManager = NetworkManager()
  private var expectedDate: String? = nil
  var email: String = ""
  var password: String = ""
  var nickname: String = ""
  var location = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    expectedBirthdayField.setBottomBorder()
    babyNameTextField.setBottomBorder()
    hideKeyboard()
  }
  
  @IBAction func editExpectedBirthDate(_ sender: UITextField) {
    calenderDatePicker.isHidden = false
    toolbar.isHidden = false
  }
  
  @IBAction func tappedCancel(_ sender: UIBarButtonItem) {
    calenderDatePicker.isHidden = true
    expectedBirthdayField.text = expectedDate
    toolbar.isHidden = true
  }
  
  @IBAction func tappedComplete(_ sender: UIBarButtonItem) {
    calenderDatePicker.isHidden = true
    toolbar.isHidden = true
  }
  
  @IBAction func calendarPickerDidChange(_ sender: UIDatePicker) {
    expectedBirthdayField.text = sender.date.toString()
    expectedDate = sender.date.toString()
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
    
    print(email, password, nickname, checkPregnant, location, babyname, babybirthday)
    
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
              print("error in userdata get에서")
              return
            }
          }
        }
      case .failure:
        return
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
  
  private func setUpView() {
    pregnantButton.definedButtonDesign()
    birthButton.definedButtonDesign()
  }
}

extension UITextField {
  func setBottomBorder() {
    self.layer.shadowColor = UIColor.darkGray.cgColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
  }
}

extension UIButton {
  func definedButtonDesign() {
    backgroundColor = .white
    layer.borderColor = UIColor.systemPink.cgColor
    layer.borderWidth = 1.0
    layer.cornerRadius = 4.0
  }
}

extension PregnantStatusViewController: StoryboardInstantiable {}
