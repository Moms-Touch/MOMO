//
//  NewPasswordInputViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/11/15.
//

import UIKit

class NewPasswordInputViewController: UIViewController {

    @IBOutlet weak var emailTextField: MomoBaseTextField!
    @IBOutlet weak var passwordTextField: MomoBaseTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var bottomConstant: CGFloat = 0
    private var isExistKeyboard = false
    private var limitTime = 180
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
    }
    
    @IBAction func resendButtonClick(_ sender: UIButton) {
        limitTime = 180
        secToTime(sec: limitTime)
    }
    
    @IBAction func sendButtonClick(_ sender: UIButton) {
        timeLabel.isHidden = false
        getSetTime()
    }
    
    @objc func getSetTime() {
        secToTime(sec: limitTime)
        limitTime -= 1
    }
    
    func secToTime(sec: Int) {
        let minute = (sec % 3600) / 60
        let second = (sec % 3600) % 60
        
        if second < 10 {
            timeLabel.text = String(minute) + ":" + "0" + String(second)
        } else {
            timeLabel.text = String(minute) + ":" + String(second)
        }
        
        if limitTime != 0 {
            perform(#selector(getSetTime), with: nil, afterDelay: 1.0)
        } else if limitTime == 0 {
            timeLabel.isHidden = true
        }
    }
    private func addView() {
        emailTextField.setBorderColor(to: UIColor(named: "Pink2")!)
        passwordTextField.setBorderColor(to: UIColor(named: "Pink2")!)
        emailTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
        loginButton.layer.cornerRadius  = 4
    }
    
    @IBAction func inputPassword(_ sender: MomoBaseTextField) {
        guard let passwordTextField = sender.text else {
            print("Password textfield is nill")
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

extension NewPasswordInputViewController: StoryboardInstantiable {}
