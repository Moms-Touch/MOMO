//
//  Login.swift
//  MOMO
//
//  Created by 오승기 on 2021/10/10.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController, StoryboardInstantiable {
    
    var idTextField = MomoBaseTextField(frame: CGRect())
    var passwordTextField = MomoBaseTextField(frame: CGRect())
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        // Do any additional setup after loading the view.
    }
    
    func addView() {
        view.addSubview(idTextField)
        view.addSubview(passwordTextField)
        
        idTextField.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(idTextField).offset(66)
            make.leading.equalTo(idTextField)
        }
        loginButton.snp.makeConstraints { make in
            make.width.equalTo(295)
            make.height.equalTo(60)
            make.top.equalTo(passwordTextField).offset(90)
            make.leading.equalTo(idTextField)
        }
        signUpButton.snp.makeConstraints { make in
            make.width.equalTo(295)
            make.height.equalTo(60)
            make.top.equalTo(loginButton).offset(79)
            make.leading.equalTo(idTextField)
        }
        passButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton).offset(82)
            make.centerX.equalToSuperview()
        }
    }
}
