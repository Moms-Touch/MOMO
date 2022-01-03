//
//  FindPasswordViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/11/15.
//

import UIKit
import Toast

protocol emailable: AnyObject {
    func convey(with emailAddress: String?)
}

final class FindPasswordViewController: UIViewController {
    @IBOutlet private weak var emailTextField: MomoBaseTextField!
    @IBOutlet private weak var temporaryPasswordButton: UIButton!
    
    weak var delegate: emailable?
    private let networkManager = NetworkManager()
    private var emailAddress: String = ""{
        willSet {
            emailAddress = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        hideKeyboard()
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
        networkManager.request(apiModel: PostApi.findPassword(email: emailAddress, contentType: .jsonData)) { [weak self] networkResult in
            print(networkResult)
            switch networkResult {
            case .success:
                self?.navigationController?.pushViewController(NewPasswordInputViewController.loadFromStoryboard(), animated: true)
                self?.delegate?.convey(with: self?.emailAddress)
            case .failure:
              self?.view.makeToast("네트워크 통신이 실패했습니다")
            }
        }
    }
    
    private func setUpView() {
        emailTextField.setBorderColor(to: Asset.Colors.pink4.color)
        emailTextField.addLeftPadding(width: 10)
        temporaryPasswordButton.alpha = 0.5
    }
}

extension FindPasswordViewController: StoryboardInstantiable { }
