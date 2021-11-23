//
//  ViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/10.
//

import UIKit
import WebKit

class SettingWebViewController: UIViewController {
  
  static let identifier = "ShowSettingWebViewController"
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var webView: WKWebView!
  
  var targetURL: URL!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let request = URLRequest(url: targetURL)
    
    webView.load(request)
    titleLabel.text = self.title
  }
  
  @IBAction func didTapDismissButton(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
}
