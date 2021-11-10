//
//  SignUpViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/10/30.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet private weak var explanationLabel: UILabel!
    private let emailTextField = MomoBaseTextField()
    private let passwordTextField = MomoBaseTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        // Do any additional setup after loading the view.
    }
    
    private func addView() {
        emailTextField.setBorderColor(to: .systemPink)
        view.addSubview(emailTextField)
//        view.addSubview(passwordTextField)
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(explanationLabel)
            make.top.equalTo(explanationLabel).offset(100)
        }
        
    }

}
// FIXME: Test를 위한 코드
extension SignUpViewController: StoryboardInstantiable { }

