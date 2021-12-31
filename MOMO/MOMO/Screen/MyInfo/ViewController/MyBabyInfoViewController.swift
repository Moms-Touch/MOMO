//
//  MyBabyInfoViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/10.
//

import UIKit

class MyBabyInfoViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var babyInfoScrollview: UIScrollView!
  @IBOutlet weak var myBabyImageView: UIImageView!
  @IBOutlet var myBabyInfoTextFields: [UITextField]! {
    didSet {
      guard let babyViewModel = babyViewModel else {return}
      let placeholders = babyViewModel.placeholders
      for index in myBabyInfoTextFields.indices {
        let textfield = myBabyInfoTextFields[index]
        textfield.textColor = Asset.Colors.pink1.color
        textfield.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        if index == 0 {
          if babyViewModel.babyName != "" {
            textfield.text = babyViewModel.babyName
          } else {
            textfield.attributedPlaceholder = NSAttributedString(string: placeholders[index], attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.pink1.color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
            textfield.font = UIFont.systemFont(ofSize: 18, weight: .medium)
          }
        } else {
          textfield.inputView = datePicker
          if babyViewModel.babyBirth != "" {
            textfield.text = babyViewModel.babyBirth
          } else {
            textfield.attributedPlaceholder = NSAttributedString(string: placeholders[index], attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.pink1.color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
            textfield.font = UIFont.systemFont(ofSize: 18, weight: .medium)
          }
        }
      }
    }
  }
  @IBOutlet weak var saveButton: UIButton! {
    didSet {
      saveButton.setRound(5)
    }
  }
  @IBOutlet var constraints: [NSLayoutConstraint]!
  
  fileprivate let picker = UIImagePickerController()
  var babyViewModel: BabyInfoViewModel?
  private var imageUrl = "default"
  private var flag = false
  private let datePicker = UIDatePicker()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addBabyImage))
    myBabyImageView.addGestureRecognizer(tapGesture)
    guard let babyViewModel = babyViewModel else {
      return
    }
    imageUrl = babyViewModel.babyImageUrl
    myBabyImageView.setImage(with: imageUrl)
    configureDatePicker()
    scrollView.delegate = self
    picker.delegate = self
  }
  
  deinit {
    print(#function, self)
  }
  
  @IBAction private func didTapBackButton(sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction private func didTapSaveButton(sender: UIButton) {
    guard let token = UserManager.shared.token else {return}
    guard let babyViewModel = babyViewModel else {
      return
    }
    babyViewModel.completionHandler = { [weak self] in
      guard let self = self else {return}
      self.myBabyInfoTextFields[0].text = babyViewModel.babyName
      self.myBabyInfoTextFields[1].text = babyViewModel.babyBirth
      self.myBabyImageView.setImage(with: babyViewModel.babyImageUrl)
    }
    guard let name = myBabyInfoTextFields[0].text else {return}
    let birth: String?
    if myBabyInfoTextFields[1].text == "" {
      birth = nil
    } else {
      birth = myBabyInfoTextFields[1].text
    }
    babyViewModel.updateBaby(token: token, name: name, birthday: birth, imageUrl: imageUrl)
    self.navigationController?.popViewController(animated: true)
  }
    
  override func viewWillLayoutSubviews() {
    if !flag {
      constraints.forEach { $0.constant = $0.constant.fit(self)}
      flag = true
    }
  }
  
  override func viewDidLayoutSubviews() {
    myBabyImageView.setRound()
    myBabyImageView.isUserInteractionEnabled = true
    myBabyInfoTextFields.forEach {$0.setRound()
      $0.addLeftPadding(width: 20)
      $0.layer.borderColor = Asset.Colors.pink4.color.cgColor
    }
    scrollingKeyboard()
  }
}

extension MyBabyInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private func openLibrary() {
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
  }
  
  private func openCamera() {
    guard !UIImagePickerController.isSourceTypeAvailable(.camera) else {
      print("Camera is not availble")
      return
    }
    picker.sourceType = .camera
    present(picker, animated: false, completion: nil)
  }
  
  @objc private func addBabyImage(sender: UIImageView) {
    let alert = UIAlertController(title: "아기 사진을 불러와주세요", message: nil, preferredStyle: .actionSheet)
    let library = UIAlertAction(title: "사진앨범", style: .default, handler: {_ in self.openLibrary()})
    let camera = UIAlertAction(title: "카메라", style: .default, handler:{ _ in self.openCamera()})
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addAction(library)
    alert.addAction(camera)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    var newImageData: Data?
    if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      newImageData = originalImage.jpegData(compressionQuality: 0.1)
      guard let newImageData = newImageData else {
        return
      }
      let imageURL: String = "\(UserManager.shared.userId)_\(Date())"
      self.imageUrl = imageURL
      StorageService.shared.uploadImageWithData(imageData: newImageData, imageName: imageURL) {
        print("uploadCompleted")
      }
      myBabyImageView.image = UIImage(data: newImageData)!
      dismiss(animated: true, completion: nil)
    }
  }
  
}

extension MyBabyInfoViewController: KeyboardScrollable, UIScrollViewDelegate {
  var scrollView: UIScrollView {
    return babyInfoScrollview
  }
  
}

//MARK: - Datepicker

extension MyBabyInfoViewController {
  
  private func addToolbar() {
    let toolbar = UIToolbar()
    toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
    toolbar.barTintColor = .white
    self.myBabyInfoTextFields[1].inputAccessoryView = toolbar
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    let done = UIBarButtonItem()
    done.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Asset.Colors.pink1.color], for: .normal)
    done.title = "완료"
    done.target = self
    done.action = #selector(datePickerDismiss)
    
    toolbar.setItems([flexSpace, done], animated: true)
  }
  
  private func configureDatePicker() {
    addToolbar()
    setAttributes()
  }
  
  private func setAttributes() {
    if #available(iOS 13.4, *) {
      datePicker.preferredDatePickerStyle = .wheels
    }
    datePicker.backgroundColor = .white
    datePicker.datePickerMode = .date
    datePicker.locale = Locale(identifier: "ko-KR")
    datePicker.timeZone = .autoupdatingCurrent
    datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
  }
  
  @objc func datePickerDismiss() {
    self.view.endEditing(true)
  }
  
  @objc func handleDatePicker(_ sender: UIDatePicker) {
    self.myBabyInfoTextFields[1].text = sender.date.toString()
  }
  
}
