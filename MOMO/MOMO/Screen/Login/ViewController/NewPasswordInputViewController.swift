//
//  NewPasswordInputViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/11/15.
//

import UIKit

final class NewPasswordInputViewController: UIViewController {

    @IBOutlet private weak var emailTextField: MomoBaseTextField!
    @IBOutlet private weak var passwordTextField: MomoBaseTextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var loginBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timeLabel: UILabel!
    
    private var bottomConstant: CGFloat = 0
    private var isExistKeyboard = false
    private var expiredTime = 180 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    //Timer 지원해줌
    @IBAction func resendButtonClick(_ sender: UIButton) {
        expiredTime = 180
        secToTime(sec: expiredTime)
    }
    
    @IBAction func sendButtonClick(_ sender: UIButton) {
        timeLabel.isHidden = false
        getSetTime()
    }
    
    @objc func getSetTime() {
        secToTime(sec: expiredTime)
        expiredTime -= 1
    }
    
    func secToTime(sec: Int) {
        let minute = (sec % 3600) / 60
        let second = (sec % 3600) % 60
        
        if second < 10 {
            timeLabel.text = String(minute) + ":" + "0" + String(second)
        } else {
            timeLabel.text = String(minute) + ":" + String(second)
        }
        
        if expiredTime != 0 {
            perform(#selector(getSetTime), with: nil, afterDelay: 1.0)
        } else if expiredTime == 0 {
            timeLabel.isHidden = true
        }
    }
    private func setUpView() {
        emailTextField.setBorderColor(to: Asset.Colors.pink2.color)
        passwordTextField.setBorderColor(to: Asset.Colors.pink2.color)
        emailTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
        loginButton.layer.cornerRadius  = 4
    }
    
    @IBAction func insertPassword(_ sender: MomoBaseTextField) {
        guard let passwordTextField = sender.text else {
            print("error: sender.text is nil")
            return
        }
        
        if !passwordTextField.isEmpty {
            loginButton.isUserInteractionEnabled = true
            loginButton.alpha = 1
        }
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
                bottomConstant = loginBottomConstraint.constant
                loginBottomConstraint.constant = keyboardFrame.cgRectValue.height
                isExistKeyboard = true
            }
        }
    }
    
    @objc private func addKeyboardWiilHide(_ notification: Notification) {
        if isExistKeyboard {
            loginBottomConstraint.constant = bottomConstant
            isExistKeyboard = false
        }
    }
}
