//
//  LocationViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/11/13.
//

import UIKit

final class LocationViewController: UIViewController {
    @IBOutlet private weak var explanationLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var LocationTextField: MomoBaseTextField!
    @IBOutlet private weak var cityNamePickerView: UIPickerView!
    
    private let cityName = ["서울", "대전", "대구", "부산", "광주", "울산", "인천"]
    private var selectedCity = ""           // nil or seoul
    
    private var bottomConstant: CGFloat = 0
    private var isExistPickerView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationTextField.delegate = self
        setUpView()
    }
    
    private func setUpView() {
        LocationTextField.setBorderColor(to: Asset.Colors.pink2.color)
        LocationTextField.addLeftPadding(width: 10)
    }
    
    @objc private func clickDoneButton() {
        LocationTextField.resignFirstResponder()
        LocationTextField.text = selectedCity
        nextButtonBottomConstraint.constant = bottomConstant
        cityNamePickerView.isHidden = true
    }
    
    @objc private func clickCancelButton() {
        LocationTextField.resignFirstResponder()
        nextButtonBottomConstraint.constant = bottomConstant
        cityNamePickerView.isHidden = true
    }
    @IBAction func didTapPregnantButton(_ sender: UIButton) {
        navigationController?.pushViewController(PregnantStatusViewController.loadFromStoryboard(), animated: true)
    }
}

@available(iOS 14.0, *)
extension LocationViewController: UITextFieldDelegate {
    func pickUp(_ textField : UITextField) {
        cityNamePickerView.delegate = self
        cityNamePickerView.dataSource = self
        LocationTextField.inputView = cityNamePickerView
        
        let flexibleSpace = UIBarButtonItem.flexibleSpace()
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(clickDoneButton))
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(clickCancelButton))

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.tintColor = .gray
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        cancelButton.tintColor = .red
        LocationTextField.inputAccessoryView = toolBar
        bottomConstant = nextButtonBottomConstraint.constant
        nextButtonBottomConstraint.constant += cityNamePickerView.frame.height + toolBar.frame.height
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickUp(LocationTextField)
        cityNamePickerView.isHidden = false
    }
}

extension LocationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCity = cityName[row]
    }
}

extension LocationViewController: StoryboardInstantiable {}
