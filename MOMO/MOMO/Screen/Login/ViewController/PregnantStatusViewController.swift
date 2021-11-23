//
//  PregnantStatusViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/11/14.
//

import UIKit

final class PregnantStatusViewController: UIViewController {
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var expectedBirthdayField: UITextField!
    @IBOutlet private weak var babyNameTextField: UITextField!
    @IBOutlet private weak var pregnantButton: UIButton!
    @IBOutlet private weak var birthButton: UIButton!
    
    private var bottomConstant: CGFloat = 0
    private var isExistKeyboard = false
    private var isOnPregnantButton = false
    private var isOnBirthButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addKeyboardObserver()
        expectedBirthdayField.setBottomBorder()
        babyNameTextField.setBottomBorder()
    }
    
    @IBAction func tappedPregnantButton() {
        isOnPregnantButton = true
        isOnBirthButton = false
        changeButtonStyle()
    }
    
    @IBAction func tappedBirthButton() {
        isOnPregnantButton = false
        isOnBirthButton = true
        changeButtonStyle()
    }
    
    private func changeButtonStyle() {
        if isOnPregnantButton {
            pregnantButton.titleLabel?.textColor = .white
            pregnantButton.backgroundColor = .systemPink
            birthButton.titleLabel?.textColor = .systemPink
            birthButton.backgroundColor = .white
        } else if isOnBirthButton {
            pregnantButton.titleLabel?.textColor = .systemPink
            pregnantButton.backgroundColor = .white
            birthButton.titleLabel?.textColor = .white
            birthButton.backgroundColor = .systemPink
        }
    }
    
    private func setUpView() {
        pregnantButton.definedButtonDesign()
        birthButton.definedButtonDesign()
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
                bottomConstant = nextButtonBottomConstraint.constant
                nextButtonBottomConstraint.constant = keyboardFrame.cgRectValue.height
                isExistKeyboard = true
            }
        }
    }
    
    @objc private func addKeyboardWiilHide(_ notification: Notification) {
        if isExistKeyboard {
            nextButtonBottomConstraint.constant = bottomConstant
            isExistKeyboard = false
        }
    }
}

extension UITextField {
    func setBottomBorder() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UIButton {
    func definedButtonDesign() {
        backgroundColor = .white
        layer.borderColor = UIColor.systemPink.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0
    }
}
