//
//  RecommendDetailViewController.swift
//  MOMO
//
//  Created by abc on 2021/12/09.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class RecommendDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, StoryboardInstantiable, ViewModelBindableType {
  
  // MARK: BindViewmodel
  func bindViewModel() {
    guard let viewModel = viewModel else {return}
    // output
    viewModel.output.bookmark
      .drive(bookmarkButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    viewModel.output.url
      .debug()
      .drive(onNext: { [unowned self] url in
        self.loadURL(url: url)
      })
      .disposed(by: disposeBag)
    
    // input
    bookmarkButton.rx.tap
      .bind(to: viewModel.input.bookmarkButtonClick)
      .disposed(by: disposeBag)

  }
  
  var viewModel: RecommendDetailViewModel?
  private var disposeBag = DisposeBag()
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var bookmarkButton: UIButton!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel()
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

}
