//
//  RecommendDetailViewController.swift
//  MOMO
//
//  Created by abc on 2021/12/09.
//

import UIKit
import WebKit

class infoDataViewModel {
  
  var model = InfoData(infoId: 1, author: "", title: "임산부에게는 이게 안좋아요ㅠ", url: "https://www.google.com", thumbnailImageURL: nil, week: 7, createdAt: "2021.11.11", updatedAt: "2021.12.12")
    
  var url: URL {
    return URL(string: model.url)!
  }
  
  var thumbNailImageURL: URL? {
    guard let thumbnailImageURL = model.thumbnailImageURL else {return nil}
    return URL(string: thumbnailImageURL)!
  }
  
  var isbookMark: Bool {
    return false
  }
}

class RecommendDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, StoryboardInstantiable {
  
  var viewModel = infoDataViewModel()
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var bookmarkButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadURL(url: viewModel.url)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  private func loadURL(url: URL) {
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
    bookmarkButton.isSelected = !bookmarkButton.isSelected
  }
  
  @IBAction func didTapDirectToLink(_ sender: UIButton) {
    let storyboard = UIStoryboard(name: "MySetting", bundle: nil)
    guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingWebViewController") as? SettingWebViewController else {return}
    vc.targetURL = viewModel.url
    present(vc, animated: true, completion: nil)
  }
  
}
