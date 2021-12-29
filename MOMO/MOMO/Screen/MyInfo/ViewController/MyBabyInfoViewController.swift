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
      let placeholders = [babyViewModel.babyName, babyViewModel.babyBirth]
      for index in myBabyInfoTextFields.indices {
        let textfield = myBabyInfoTextFields[index]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholders[index], attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.pink1.color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
        textfield.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textfield.addLeftPadding(width: 20)
        textfield.layer.borderColor = Asset.Colors.pink4.color.cgColor
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
  private var flag = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addBabyImage))
    myBabyImageView.addGestureRecognizer(tapGesture)
    guard let babyViewModel = babyViewModel else {
      return
    }
    myBabyImageView.setImage(with: babyViewModel.babyImageUrl)
    scrollView.delegate = self
    picker.delegate = self
  }
  
  @IBAction private func didTapBackButton(sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction private func didTapSaveButton(sender: UIButton) {
    
  }
    
  override func viewWillLayoutSubviews() {
    if !flag {
      constraints.forEach { $0.constant = $0.constant.fit(self)}
      flag = true
    }
  }
  
  override func viewDidLayoutSubviews() {
    myBabyImageView.setRound()
    myBabyInfoTextFields.forEach {$0.setRound()}
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
      let imageURL: String = "userID_\(Date())"
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


