//
//  Login.swift
//  MOMO
//
//  Created by 오승기 on 2021/10/10.
//

import UIKit

@IBDesignable
final class LoginViewController: ViewController {
  
  @IBOutlet private weak var idTextField: MomoBaseTextField! {
    didSet {
      idTextField.setUpFontStyle()
    }
  }
  @IBOutlet private weak var passwordTextField: MomoBaseTextField! {
    didSet {
      passwordTextField.setUpFontStyle()
    }
  }
  @IBOutlet private weak var loginButton: UIButton!
  @IBOutlet private weak var signUpButton: UIButton!
  @IBOutlet private weak var passThroughButton: UIButton!
  @IBOutlet private weak var checkBoxView: UIView!
  @IBOutlet private weak var checkBoxLabel: UILabel!
  
  private let networkManager = NetworkManager()
  private var container = UIView()
  private var loadingView = UIView()
  private var activityIndicator = UIActivityIndicatorView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    idTextField.setBorderColor(to: .white)
    passwordTextField.setBorderColor(to: .white)
    idTextField.addLeftPadding(width: 10)
    passwordTextField.addLeftPadding(width: 10)
    checkBoxView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkBoxClicked)))
    hideKeyboard()
    setTextFieldDelegate()
    setUpButtonUI()
  }
  
  @objc func checkBoxClicked() {
    if checkBoxLabel.isHidden == false {
      checkBoxLabel.isHidden = true
      passwordTextField.isSecureTextEntry = true
    } else {
      checkBoxLabel.isHidden = false
      passwordTextField.isSecureTextEntry = false
    }
  }
  
  private func setUpButtonUI() {
    loginButton.momoButtonStyle()
    signUpButton.momoButtonStyle()
  }
  
  private func showActivityIndicator() {
    container.frame = view.frame
    container.center = view.center
    container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
    
    loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
    loadingView.center = view.center
    loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
    activityIndicator.style = UIActivityIndicatorView.Style.large
    activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    view.addSubview(container)
    activityIndicator.startAnimating()
  }
  
  private func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
  }
  
  private func hideActivityIndicator() {
    activityIndicator.stopAnimating()
    container.removeFromSuperview()
  }
  
  private func moveToHomeMainView() {
    DispatchQueue.main.async {
      //navigationbar없애야함.
      self.navigationController?.pushViewController(HomeMainViewController.loadFromStoryboard(), animated: false)
    }
  }
  
  private func failLogin() {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: "로그인실패",
                                    message: "아이디와 비밀번호를 확인해주세요",
                                    preferredStyle: .alert)
      let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
      alert.addAction(confirm)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  @IBAction func didTapLoginButton(_ sender: UIButton) {
    guard let id = idTextField.text, let password = passwordTextField.text else {
      return
    }
    showActivityIndicator()
    let loginData = PostApi.login(email: id, password: password, contentType: .jsonData)
    networkManager.request(apiModel: loginData) { [weak self] networkResult in
      switch networkResult {
      case .success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: LoginData.self) { body in
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
              parsingManager.judgeGenericResponse(data: data, model: UserData.self) { body in
                UserManager.shared.userInfo = body
                DispatchQueue.main.async { [weak self] in
                  let home = TabBar()
                  home.selectedIndex = 0
                  let newNaviController = UINavigationController(rootViewController: home)
                  newNaviController.isNavigationBarHidden = true
                  let sceneDelegate = UIApplication.shared.connectedScenes
                    .first!.delegate as! SceneDelegate
                  sceneDelegate.window!.rootViewController = newNaviController
                }
              }
            case .failure(_):
              print("error in userdata get에서")
              return
            }
          }
        }
      case .failure:
        self?.failLogin()
      }
      DispatchQueue.main.async {
        self?.hideActivityIndicator()
      }
    }
  }
  
  @IBAction func didTapSignUpButton(_ sender: UIButton) {
    navigationController?.pushViewController(SignUpViewController.loadFromStoryboard(), animated: true)
  }
  
  @IBAction func didTapFindPasswordButton(_ sender: UIButton) {
    navigationController?.pushViewController(FindPasswordViewController.loadFromStoryboard(), animated: true)
  }
}

extension LoginViewController: StoryboardInstantiable { }

// Accessability
extension LoginViewController: UITextFieldDelegate {
  private func setTextFieldDelegate(){
    idTextField.delegate = self
    passwordTextField.delegate = self
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == idTextField {
      textField.resignFirstResponder()
      passwordTextField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return true
  }
}
