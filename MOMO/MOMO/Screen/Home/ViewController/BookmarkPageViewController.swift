//
//  BookmarkPageViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/15.
//

import UIKit

final class BookmarkPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  
  let VCArray = [PolicyBookmarkTableViewController.loadFromStoryboard(), CommuntiyBookmarkTableViewController.loadFromStoryboard()]
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let VCIndex = VCArray.firstIndex(of: viewController as! UITableViewController) else {return nil}
    let prevIndex = VCIndex - 1
    if prevIndex < 0 {
      return nil
    } else {
      return VCArray[prevIndex]
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let VCIndex = VCArray.firstIndex(of: viewController as! UITableViewController) else {return nil}
    let nextIndex = VCIndex + 1
    if nextIndex >= VCArray.count {
      return nil
    } else {
      return VCArray[nextIndex]
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      var VCIndex = 0
      if let currentVC = pageViewController.viewControllers?[0] as? PolicyBookmarkTableViewController {
        VCIndex = 0
      } else if let currentVC = pageViewController.viewControllers?[0] as? CommuntiyBookmarkTableViewController {
        VCIndex = 1
      }
      NotificationCenter.default.post(name: NSNotification.Name("SegControlNotification"), object: VCIndex)
    }
  }
  
  override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.dataSource = self
    self.delegate = self
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
