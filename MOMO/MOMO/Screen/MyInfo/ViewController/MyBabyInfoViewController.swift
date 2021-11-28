//
//  MyBabyInfoViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/10.
//

import UIKit
import Photos

class MyBabyInfoViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var myBabyImageView: UIImageView! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addBabyImage))
      myBabyImageView.addGestureRecognizer(tapGesture)
    }
  }
  @IBOutlet var myBabyInfoTextFields: [UITextField]! {
    didSet {
      for index in myBabyInfoTextFields.indices {
        let textfield = myBabyInfoTextFields[index]
        textfield.attributedPlaceholder = NSAttributedString(string: BabyEditTextfields.allCases[index].rawValue, attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.pink1, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
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
  
  fileprivate let picker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    picker.delegate = self
    // Do any additional setup after loading the view.
  }
  
}

extension MyBabyInfoViewController {
  enum BabyEditTextfields: String, CaseIterable {
    case babyName = "아기이름"
    case birth = "출생일/출생예정일"
  }
}

extension MyBabyInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private func openLibrary() {
    if #available(iOS 14, *) {
      //PHAsset
    } else {
      picker.sourceType = .photoLibrary
      picker.allowsEditing = true
      present(picker, animated: true, completion: nil)
    }
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
}
