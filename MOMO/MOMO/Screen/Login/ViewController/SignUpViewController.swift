//
//  SignUpViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/10/30.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var explanationLabel: UILabel!
    @IBOutlet private weak var emailTextField: MomoBaseTextField!
    @IBOutlet private weak var passwordTextField: MomoBaseTextField!
    @IBOutlet weak var nicknameTextField: MomoBaseTextField!
    @IBOutlet private weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        hideKeyboard()
    }
    
    private func setUpView() {
        emailTextField.setBorderColor(to: Asset.Colors.pink2.color)
        passwordTextField.setBorderColor(to: Asset.Colors.pink2.color)
        nicknameTextField.setBorderColor(to: Asset.Colors.pink2.color)
        emailTextField.addLeftPadding(width: 10)
        passwordTextField.addLeftPadding(width: 10)
        nicknameTextField.addLeftPadding(width: 10)
    }
    
    @IBAction func didTapLocationButton(_ sender: UIButton) {
        guard let locationVC = LocationViewController.loadFromStoryboard() as? LocationViewController else {
            print("locationVC empty")
            return
        }
        locationVC.email = emailTextField.text ?? ""
        locationVC.password = passwordTextField.text ?? ""
        locationVC.nickname = nicknameTextField.text ?? ""
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapDoubleCheck(_ sender: UIButton) {
        guard let nickname = nicknameTextField.text else {
            print("닉네임을 입력안함")
            return
        }
        let networkManager = NetworkManager()
        networkManager.request(apiModel: GetApi.nicknameGet(nickname: nickname)) { [weak self] result in
            print(result)
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.nextButton.alpha = 1
                    self?.nextButton.isUserInteractionEnabled = true
                }
            case .failure:
                print("닉네임이 중복되었습니다 다시 입력해주세요.")
            }
        }
    }
}

extension SignUpViewController: StoryboardInstantiable { }
