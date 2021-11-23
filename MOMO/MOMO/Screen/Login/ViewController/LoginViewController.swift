//
//  Login.swift
//  MOMO
//
//  Created by 오승기 on 2021/10/10.
//

import UIKit

@IBDesignable
final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var idTextField: MomoBaseTextField!
    @IBOutlet private weak var passwordTextField: MomoBaseTextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var passThroughButton: UIButton!
    @IBOutlet private weak var checkBoxView: UIView!
    @IBOutlet private weak var checkBoxLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
        checkBoxView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkBoxClicked)))
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
}

extension LoginViewController: StoryboardInstantiable { }
