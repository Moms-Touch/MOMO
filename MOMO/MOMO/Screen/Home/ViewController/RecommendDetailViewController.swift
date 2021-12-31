//
//  RecommendDetailViewController.swift
//  MOMO
//
//  Created by abc on 2021/12/09.
//

import UIKit
import WebKit

class RecommendDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, StoryboardInstantiable {
  
//  var viewModel: InfoDataViewModel?
  var postCompletionHandler: ((Int)->Void)?
  var deleteCompletionHandler: ((Int)->Void)?
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var bookmarkButton: UIButton! {
    didSet {
      guard let data = data else {
        return
      }
      if data.isBookmark == true {
        bookmarkButton.isSelected = true
      } else {
        bookmarkButton.isSelected = false
      }
    }
  }
  var data: InfoData?
  var index: Int = 0
  lazy var networkingManager = NetworkManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let data = data else {
      return
    }
    
    print("ㄸ", data.id)
    let url = URL(string: data.url!)
    loadURL(url: url)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  private func loadURL(url: URL?) {
    guard let url = url else {
      return
    }
    let request = URLRequest(url: url)
    webView.load(request)
    webView.uiDelegate = self
    webView.navigationDelegate = self
  }
  
  func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
    webView.reload()
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didTapBookmarkButton(_ sender: UIButton) {
    guard let token = UserManager.shared.token else {return}
    guard var data = data else {
      return
    }
    if data.id != -1 {
      if data.isBookmark == false {
        networkingManager.request(apiModel: PostApi.postBookmark(token: token, postId: data.id, postCategory: .info)) { [weak self] (result) in
          guard let self = self else {return}
          switch result {
          case .success(_):
            DispatchQueue.main.async {
              self.bookmarkButton.isSelected = true
              self.data?.isBookmark = true
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
        networkingManager.request(apiModel: DeleteApi.deleteBookmark(token: token, postId: data.id, postCategory: .info)) { [weak self] (result) in
          guard let self = self else {return}
          switch result {
          case .success(_):
            DispatchQueue.main.async {
              self.data?.isBookmark = false 
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
  
  @IBAction func didTapDirectToLink(_ sender: UIButton) {
    let storyboard = UIStoryboard(name: "MySetting", bundle: nil)
    guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingWebViewController") as? SettingWebViewController else {return}
    guard let data = data else {
      return
    }
    vc.targetURL = URL(string: data.url!)
    present(vc, animated: true, completion: nil)
  }
  
}
