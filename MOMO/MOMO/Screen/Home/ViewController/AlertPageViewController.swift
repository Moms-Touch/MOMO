//
//  AlertPageViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/29.
//

import UIKit

final class AlertPageViewController: MomoPageViewController {
  
  static let pageControlNotification: NSNotification.Name = NSNotification.Name("AlertPageControlNotification")
  
  private var alertVCArray = [AlertTableViewController(style: .grouped), MessageTableViewController(style: .grouped)]
  
  override var VCArray: [UIViewController] {
    get {
      return alertVCArray
    }
    set {
      super.VCArray = newValue
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      var VCIndex = 0
      if let _ = pageViewController.viewControllers?[0] as? AlertTableViewController {
        VCIndex = 0
      } else if let _ = pageViewController.viewControllers?[0] as? MessageTableViewController {
        VCIndex = 1
      }
      
      NotificationCenter.default.post(name: AlertViewController.alertSegNotification, object: VCIndex)
      
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let firstVC = VCArray.first {
      setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    NotificationCenter.default.addObserver(self, selector: #selector(setVC(_:)), name: AlertPageViewController.pageControlNotification, object: nil)
    
  }
  
  @objc private func setVC(_ notification: Notification) {
    let getValue = notification.object as! Int
    if getValue == 0 {
      setViewControllers([VCArray[getValue]], direction: .reverse, animated: true, completion: nil)
    } else {
      setViewControllers([VCArray[getValue]], direction: .forward, animated: true, completion: nil)
    }
  }
  
}
