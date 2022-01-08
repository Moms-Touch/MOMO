//
//  LocationViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/11/13.
//

import UIKit

final class LocationViewController: UIViewController {
  @IBOutlet private weak var explanationLabel: UILabel!
  @IBOutlet private weak var nextButton: UIButton!
  @IBOutlet private weak var nextButtonBottomConstraint: NSLayoutConstraint!
  @IBOutlet private weak var locationTextField: MomoBaseTextField! {
    didSet {
      locationTextField.inputView = cityNamePickerView
      locationTextField.setUpFontStyle()
    }
  }

  //false이면 회원가입
  //true이면 회원수정
  
  var editMode = false
  
  var email: String = ""
  var password: String = ""
  var nickname: String = ""
  
  private var cityNamePickerView = UIPickerView()
  private let cityName = ["서울", "대전", "대구", "부산", "광주", "울산", "인천"]
  private var selectedCity = ""           // nil or seoul
  
  
  private var bottomConstant: CGFloat = 0
  private var isExistPickerView = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    cityNamePickerView.delegate = self
    setUpView()
    configurePickerView()
    addToolbar()
    hideKeyboard()
    setUpButtonUI()
  }
  
  private func setUpButtonUI() {
    if editMode == true {
      nextButton.setTitle("저장", for: .normal)
    }
    nextButton.momoButtonStyle()
  }
  
  private func setUpView() {
    locationTextField.setBorderColor(to: Asset.Colors.pink2.color)
    locationTextField.addLeftPadding(width: 10)
    if editMode == true {
      locationTextField.text = UserManager.shared.userInfo?.location
      guard let city = UserManager.shared.userInfo?.location else {
        return
      }
      selectedCity = city
    }
  }
  
  //다음버튼
  @IBAction func didTapPregnantButton(_ sender: UIButton) {
    if editMode == true { // 회원수정
      
      guard let token = UserManager.shared.token else {
        self.view.makeToast("로그인해주세요")
        return}
      
      guard let userInfo = UserManager.shared.userInfo else {
        self.view.makeToast("로그인해주세요")
        return
      }
      
      print(selectedCity)
      
      let networkingManager = NetworkManager()
      networkingManager.request(apiModel: PutApi.putUser(token: token, email: userInfo.email, nickname: userInfo.nickname, isPregnant: userInfo.isPregnant, hasChild: userInfo.hasChild, age: userInfo.age, location: selectedCity)) { [weak self] (result) in
        guard let self = self else { return }
        switch result {
        case .success(let data):
          let parsingmanager = ParsingManager()
          parsingmanager.judgeGenericResponse(data: data, model: UserData.self) { (userdata) in
            DispatchQueue.main.async {
              UserManager.shared.userInfo = userdata
              self.dismiss(animated: true, completion: nil)
            }
          }
        case .failure(let error):
          print(error)
          DispatchQueue.main.async {
            self.view.makeToast("저장 실패했습니다. 다시 시도해주세요")
            self.dismiss(animated: true, completion: nil)
          }
        }
      }
      
      
    } else {
      guard let pregnantVC = PregnantStatusViewController.loadFromStoryboard() as? PregnantStatusViewController else {
        print("pregnantVC empty")
        return
      }
      pregnantVC.email = email
      pregnantVC.password = password
      pregnantVC.nickname = nickname
      pregnantVC.location = locationTextField.text ?? "전국"
      
      navigationController?.pushViewController(pregnantVC, animated: true)
    }
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    if editMode == true {
      self.dismiss(animated: true, completion: nil)
    }
    navigationController?.popViewController(animated: true)
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    cityNamePickerView.isHidden = false
  }
}
  


extension LocationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return cityName.count
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    let pickerLabel = UILabel()
    pickerLabel.textAlignment = .center
    pickerLabel.textColor = Asset.Colors.pink1.color
    pickerLabel.font = UIFont.systemFont(ofSize: 24)
    pickerLabel.text = cityName[row]
    return pickerLabel
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedCity = cityName[row]
    locationTextField.text = selectedCity
  }
}

extension LocationViewController: StoryboardInstantiable {}

extension LocationViewController {
  
  private func configurePickerView() {
    cityNamePickerView.backgroundColor = .systemGray6
  }
  
  private func addToolbar() {
    let toolbar = UIToolbar()
    toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
    toolbar.barTintColor = .systemGray6
    self.locationTextField.inputAccessoryView = toolbar
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    let done = UIBarButtonItem()
    done.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Asset.Colors.pink1.color], for: .normal)
    done.title = "완료"
    done.accessibilityLabel = "완료하기 버튼"
    done.target = self
    done.action = #selector(pickerDone(_:))
    
    toolbar.setItems([flexSpace, done], animated: true)
    
  }
  
  @objc private func pickerDone(_ sender: UIPickerView) {
    self.view.endEditing(true)
  }
  
  
}
