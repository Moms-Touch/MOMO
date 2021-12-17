//
//  SignUpViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/10/30.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var explanationLabel: UILabel!
    @IBOutlet private weak var emailTextField: MomoBaseTextField!
    @IBOutlet private weak var passwordTextField: MomoBaseTextField!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var nextButtonConstraint: NSLayoutConstraint!
    
    private var bottomConstant: CGFloat = 0
    private var isExistKeyboard = false
    let networkManager = NetworkManager()
    let parsingManager = ParsingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addKeyboardObserver()
    }
    
    private func setUpView() {
        emailTextField.setBorderColor(to: Asset.Colors.pink2.color)
        passwordTextField.setBorderColor(to: Asset.Colors.pink2.color)
      emailTextField.addLeftPadding(width: 10)
        passwordTextField.addLeftPadding(width: 10)
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addKeyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addKeyboardWiilHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func addKeyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if !isExistKeyboard {
                bottomConstant = nextButtonConstraint.constant
                nextButtonConstraint.constant = keyboardFrame.cgRectValue.height
                isExistKeyboard = true
            }
        }
    }
    
    @objc private func addKeyboardWiilHide(_ notification: Notification) {
        if isExistKeyboard {
            nextButtonConstraint.constant = bottomConstant
            isExistKeyboard = false
        }
    }
    @IBAction func didTapLocationButton(_ sender: UIButton) {
        navigationController?.pushViewController(LocationViewController.loadFromStoryboard(), animated: true)
        let test = PostApi.registProfile(email: "ohsg0272@naver.com", password: "123", nickname: "12", isPregnant: true, hasChild: true, age: 123, location: "seoul", contentType: .jsonData)
        networkManager.request(apiModel: test) { networkResult  in
            switch networkResult {
            case .success(let data):
                print(data)
                print(test)
            case .failure(_):
                print("error")
            }
        }
    }
}

extension SignUpViewController: StoryboardInstantiable { }
