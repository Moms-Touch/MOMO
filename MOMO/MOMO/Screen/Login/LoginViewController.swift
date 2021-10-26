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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        // Do any additional setup after loading the view.
    }
    
    func addView() {
        view.addSubview(idTextField)
        view.addSubview(passwordTextField)
        
        idTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(369)
            make.leading.equalToSuperview().offset(39)
        }
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(idTextField).offset(66)
            make.leading.equalTo(idTextField)
        }
        
//
//        NSLayoutConstraint.activate([idTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 39),
//                                     idTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 369)])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
