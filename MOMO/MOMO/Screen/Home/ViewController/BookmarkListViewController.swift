//
//  BookmarkListViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/15.
//

import UIKit

final class BookmarkListViewController: UIViewController, StoryboardInstantiable, SegControlCustomable {
  
  var segmentedControl: UISegmentedControl {
    return bookmarkSegControl
  }
  
  var segmentedControlTextColor: (selected: ColorAsset.Color, unselected: ColorAsset.Color) {
    return (selected: Asset.Colors.pink4.color, unselected: Asset.Colors._71.color)
  }
  
  var segmentedConrolBackgroundColor: UIColor {
    return .white
  }
  

  @IBOutlet weak var bookmarkSegControl: UISegmentedControl!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      NotificationCenter.default.addObserver(self, selector: #selector(getpageIndex(_:)),
                                             name: NSNotification.Name("SegControlNotification"),
                                             object: nil)
      setupSegmentedControl()
      setBorder(color: Asset.Colors.pink5.color)
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
  
}

extension BookmarkListViewController {
    @IBAction func didTapBackButton(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
    }
}
