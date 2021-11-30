//
//  AlertViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/29.
//

import UIKit

final class AlertViewController: UIViewController, StoryboardInstantiable {
  
  static let alertSegNotification: NSNotification.Name = NSNotification.Name("AlertSegControlNotification")
  
  @IBOutlet weak var alertSegControl: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSegmentedControl()
    setBorder(color: Asset.Colors.pink5.color)
    NotificationCenter.default.addObserver(self, selector: #selector(getpageIndex(_:)), name: AlertViewController.alertSegNotification, object: nil)
  }
  
  @objc func getpageIndex(_ noti: Notification) {
    var getValue = noti.object as! Int
    if getValue < 0 {
      getValue = 0 } else if getValue >= 2 {
        getValue = 1
      }
    alertSegControl.selectedSegmentIndex = getValue
  }
  
  @IBAction func didChangeAlertSegControl(_ sender: UISegmentedControl) {
    NotificationCenter.default.post(name: AlertPageViewController.pageControlNotification, object: sender.selectedSegmentIndex)
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
}

extension AlertViewController: MomoPageable {
  var segmentedControl: UISegmentedControl {
    return alertSegControl
  }
  
  var segmentedControlTextColor: (selected: ColorAsset.Color, unselected: ColorAsset.Color) {
    return (selected: Asset.Colors.pink4.color, unselected: Asset.Colors._71.color)
  }
  
  var segmentedConrolBackgroundColor: UIColor {
    return .white
  }
}
