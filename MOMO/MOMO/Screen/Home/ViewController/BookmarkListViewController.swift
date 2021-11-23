//
//  BookmarkListViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/15.
//

import UIKit

final class BookmarkListViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var bookmarkSegControl: UISegmentedControl! {
    didSet {
      bookmarkSegControl.removeBorder()
      bookmarkSegControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : Asset.Colors.pink4.color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)], for: .selected)
      bookmarkSegControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : Asset.Colors._71.color, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .bold)], for: .normal)
      bookmarkSegControl.addBorder([.bottom], color: Asset.Colors.pink5.color, width: 3)
    }
  }
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      NotificationCenter.default.addObserver(self, selector: #selector(getpageIndex(_:)),
                                             name: NSNotification.Name("SegControlNotification"),
                                             object: nil)
    }
    
  
  @objc func getpageIndex(_ notification: Notification) {
    var getValue = notification.object as! Int
    print(getValue)
    if getValue < 0 {
      getValue = 0
    } else if getValue >= 2 {
      getValue = 1
    }
    bookmarkSegControl.selectedSegmentIndex = getValue
  }

  @IBAction func didChangeBookmarkSegControl(_ sender: UISegmentedControl) {
    NotificationCenter.default.post(name: NSNotification.Name("PageControlNotification"), object: bookmarkSegControl.selectedSegmentIndex)
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}
