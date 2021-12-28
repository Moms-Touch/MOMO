//
//  RecommendDetailViewController.swift
//  MOMO
//
//  Created by abc on 2021/12/09.
//

import UIKit
import WebKit

class RecommendDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, StoryboardInstantiable {
  
  var viewModel: InfoDataViewModel?
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var bookmarkButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let viewModel = viewModel else {
      return
    }
    loadURL(url: viewModel.url)
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
    bookmarkButton.isSelected = !bookmarkButton.isSelected
  }
  
  @IBAction func didTapDirectToLink(_ sender: UIButton) {
    let storyboard = UIStoryboard(name: "MySetting", bundle: nil)
    guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingWebViewController") as? SettingWebViewController else {return}
    guard let viewModel = viewModel else {
      return
    }
    vc.targetURL = viewModel.url
    present(vc, animated: true, completion: nil)
  }
  
}
