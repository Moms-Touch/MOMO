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
    @IBOutlet weak var sendButton: UIButton!
    
    private var bottomConstant: CGFloat = 0
    private var isExistKeyboard = false
    private var expiredTime = 20
    var firstClickSendButton = true
    
    var timer = Timer()
//    lazy let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        emailTextField.setBorderColor(to: Asset.Colors.pink2.color)
        passwordTextField.setBorderColor(to: Asset.Colors.pink2.color)
        emailTextField.addLeftPadding(width: 10)
        passwordTextField.addLeftPadding(width: 10)
        loginButton.layer.cornerRadius  = 4
    }
    
    @IBAction func test(_ sender: UIButton) {
        timeLabel.isHidden = false
        if firstClickSendButton {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            firstClickSendButton = false
            sendButton.setTitle("재전송", for: .normal)
        } else {
            stopTimer()
            expiredTime = 20
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        timer.invalidate()
    }

    @objc func updateCounter() {
        expiredTime -= 1
        let seconds = expiredTime % 60
        let minutes = (expiredTime / 60) % 60
        let strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds) : "0" + String(seconds)
        if seconds > 0 {
            timeLabel.text = "\(strMinutes):\(strSeconds)"
        } else {
            stopTimer()
            timeLabel.isHidden = true
        }
    }

    
//    @IBAction func insertPassword(_ sender: MomoBaseTextField) {
//        guard let passwordTextField = sender.text else {
//            print("error: sender.text is nil")
//            return
//        }
//
//        if !passwordTextField.isEmpty {
//            loginButton.isUserInteractionEnabled = true
//            loginButton.alpha = 1
//        }
//    }
    
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
