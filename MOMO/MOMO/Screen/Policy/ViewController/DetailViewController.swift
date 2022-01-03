//
//  DetailViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var hostAssocitationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var policyImageView: UIImageView!
  @IBOutlet weak var policyContentView: UILabel!
  @IBOutlet weak var goButton: UIButton!
  @IBOutlet weak var bookmarkButton: UIButton! {
    didSet {
      guard let data = policyData else {
        return
      }
      if data.isBookmark == true {
        bookmarkButton.isSelected = true
      } else {
        bookmarkButton.isSelected = false
      }
    }
  }
  
  var content: Any?
  private var policyData: PolicyData?
  private var index: Int = 0
  private var postCompletionHandler: ((Int)->Void)?
  private var deleteCompletionHandler: ((Int)->Void)?
  lazy var networkingManager = NetworkManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    showDetailPolicy()
  }
  
  func configure(policyData: PolicyData) {
    self.policyData = policyData
  }
 
  private func showDetailPolicy() {
    guard let policyData = policyData else {
      print("policyData is nil")
      return
    }
    titleLabel.text = policyData.title
    hostAssocitationLabel.text = policyData.author
    dateLabel.text = policyData.createdAt.trimStringDate()
    policyContentView.text = EnterString(content: policyData.content)
    if let image = policyData.thumbnailImageUrl {
      policyImageView.image = UIImage(named: image)
    }
  }
  
  private func EnterString(content: String) -> String {
    var stringMap = content.map {$0}
    while index < stringMap.count {
      if stringMap[index] == "►" && index != 0 {
        stringMap.insert("\n", at: index)
        index += 1
      }
      index += 1
    }
    return String(stringMap)
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func didTapShorcutButton(_ sender: UIButton) {
    guard let policyURL = policyData?.url else {
      print("유효하지 않은 URL입니다")
      return
    }
    if let url = URL(string: policyURL) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
  @IBAction func didTapBookmarkButton(_ sender: UIButton) {
    guard let token = UserManager.shared.token else { return }
    guard let data = policyData else {
      return
    }
    if data.id != -1 {
      if data.isBookmark == false {
        networkingManager.request(apiModel: PostApi.postBookmark(token: token, postId: data.id, postCategory: .policy)) { [weak self] (result) in
          guard let self = self else {return}
          switch result {
          case .success(_):
            DispatchQueue.main.async {
              self.bookmarkButton.isSelected = true
              self.policyData?.isBookmark = true
              guard let completionHandler = self.postCompletionHandler else {
                return
              }
              completionHandler(data.id)
            }
          case .failure(let error):
            print(error)
          }
        }
      } else {
        networkingManager.request(apiModel: DeleteApi.deleteBookmark(token: token, postId: data.id, postCategory: .policy)) { [weak self] (result) in
          guard let self = self else {return}
          switch result {
          case .success(_):
            DispatchQueue.main.async {
              self.policyData?.isBookmark = false
              self.bookmarkButton.isSelected = false
              guard let deleteCompletionHandler = self.deleteCompletionHandler else {
                return
              }
              deleteCompletionHandler(self.index)
            }
          case .failure(let error):
            print(error)
          }
        }
      }
    }
  }
}

extension DetailViewController: StoryboardInstantiable {}


