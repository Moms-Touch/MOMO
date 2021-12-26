//
//  FindPasswordViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/11/15.
//

import UIKit

protocol emailable: AnyObject {
    func convey(with emailAddress: String?)
}

final class FindPasswordViewController: UIViewController {
    @IBOutlet private weak var emailTextField: MomoBaseTextField!
    @IBOutlet private weak var temporaryPasswordButton: UIButton!
    @IBOutlet private weak var temporaryPasswordBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: emailable?
    private var bottomConstant: CGFloat = 0.0
    private var isExistKeyboard = false
    private let networkManager = NetworkManager()
    private var emailAddress: String = ""{
        willSet {
            emailAddress = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addKeyboardObserver()
    }
    
    private func isValidEmail(_ address: String) -> Bool {
        let emailRex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRex)
        return emailCheck.evaluate(with: address)
    }
    
    
    
    @IBAction func editEmailTextField(_ sender: MomoBaseTextField) {
        guard let text = sender.text else {
            print("error: sender.text is nil")
            return
        }
        
        if isValidEmail(text) {
            temporaryPasswordButton.alpha = 1.0
            temporaryPasswordButton.isUserInteractionEnabled = true
            emailAddress = text
        } else {
            temporaryPasswordButton.alpha = 0.5
            temporaryPasswordButton.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func didTapTemporaryPasswordButton(_ sender: UIButton) {
        print(emailAddress)
        networkManager.request(apiModel: PostApi.findPassword(email: emailAddress, contentType: .jsonData)) { [weak self] networkResult in
            switch networkResult {
            case .success:
                self?.navigationController?.pushViewController(NewPasswordInputViewController.loadFromStoryboard(), animated: true)
                self?.delegate?.convey(with: self?.emailAddress)
            case .failure:
                //alert창 띄우기
                print("fail")
            }
        }
    }
    
    private func setUpView() {
        emailTextField.setBorderColor(to: Asset.Colors.pink4.color)
        emailTextField.addLeftPadding(width: 10)
        temporaryPasswordButton.alpha = 0.5
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
                bottomConstant = temporaryPasswordBottomConstraint.constant
                temporaryPasswordBottomConstraint.constant = keyboardFrame.cgRectValue.height
                isExistKeyboard = true
            }
        }
    }
    
    @objc private func addKeyboardWiilHide(_ notification: Notification) {
        if isExistKeyboard {
            temporaryPasswordBottomConstraint.constant = bottomConstant
            isExistKeyboard = false
        }
    }
}

extension FindPasswordViewController: StoryboardInstantiable { }
