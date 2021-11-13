//
//  SignUpViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/10/30.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var explanationLabel: UILabel!
    @IBOutlet weak var emailTextField: MomoBaseTextField!
    @IBOutlet weak var passwordTextField: MomoBaseTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonConstraint: NSLayoutConstraint!
    
    var bottomConstraint: CGFloat = 0
    var isExistKeyboard = false
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        addKeyboardObserver()
        // Do any additional setup after loading the view.
    }
    
    private func addView() {
        emailTextField.setBorderColor(to: UIColor(named: "Pink2")!)
        passwordTextField.setBorderColor(to: UIColor(named: "Pink2")!)
        emailTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
        nextButton.heightAnchor.constraint(equalToConstant: 59).isActive = true
        nextButton.layer.cornerRadius  = 4
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
                bottomConstraint = nextButtonConstraint.constant
                nextButtonConstraint.constant = keyboardFrame.cgRectValue.height
                isExistKeyboard = true
            }
        }
    }
    
    @objc private func addKeyboardWiilHide(_ notification: Notification) {
        if isExistKeyboard {
            nextButtonConstraint.constant = bottomConstraint
            isExistKeyboard = false
        }
        
    }
    
}
extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        leftView = paddingView
        leftViewMode = ViewMode.always
    }
}

