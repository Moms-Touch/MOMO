//
//  FindPasswordViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/11/15.
//

import UIKit

class FindPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: MomoBaseTextField!
    @IBOutlet weak var temporaryPasswordButton: UIButton!
    @IBOutlet weak var temporaryPasswordBottomConstraint: NSLayoutConstraint!
    
    private var bottomConstant: CGFloat = 0
    private var isExistKeyboard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        addKeyboardObserver()
    }
    
    func isValidEmail(testString:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testString)
    }
    
    @IBAction func editEmailTextField(_ sender: MomoBaseTextField) {
        guard let text = sender.text else {
            print("error: sender.text is not string")
            return
        }
        
        if isValidEmail(testString: text) {
            temporaryPasswordButton.alpha = 1
            temporaryPasswordButton.isUserInteractionEnabled = true
        } else {
            temporaryPasswordButton.alpha = 0.5
            temporaryPasswordButton.isUserInteractionEnabled = false
        }
    }
    
    private func addView() {
        emailTextField.setBorderColor(to: UIColor(named: "Pink4")!)
        emailTextField.addLeftPadding()
        temporaryPasswordButton.alpha = 0.5
        temporaryPasswordButton.layer.cornerRadius  = 4
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
