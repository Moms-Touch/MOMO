//
//  BookmarkPageViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/15.
//

import UIKit

final class BookmarkPageViewController: MomoPageViewController {
  
  let bookmarkVCArray = [PolicyBookmarkTableViewController.loadFromStoryboard(), CommuntiyBookmarkTableViewController.loadFromStoryboard()]
  
  override var VCArray: [UIViewController] {
    get {
      return bookmarkVCArray
    }
    set {
      super.VCArray = newValue
    }
  }

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      var VCIndex = 0
      if let _ = pageViewController.viewControllers?[0] as? PolicyBookmarkTableViewController {
        VCIndex = 0
      } else if let _ = pageViewController.viewControllers?[0] as? CommuntiyBookmarkTableViewController {
        VCIndex = 1
      }
      NotificationCenter.default.post(name: NSNotification.Name("SegControlNotification"), object: VCIndex)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let firstVC = VCArray.first {
      setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    NotificationCenter.default.addObserver(self, selector: #selector(setVC(_:)), name: NSNotification.Name("PageControlNotification"), object: nil)
  }
  
  
  @objc func setVC(_ notification: Notification) {
    let getValue = notification.object as! Int
    if getValue == 0 {
      setViewControllers([VCArray[getValue]], direction: .reverse, animated: true, completion: nil)
    } else {
      setViewControllers([VCArray[getValue]], direction: .forward, animated: true, completion: nil)
    }
  }
  
}
