//
//  MomoPageViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/30.
//

import Foundation
import UIKit

class MomoPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  
  var VCArray: [UIViewController] = []
  
  override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
    
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.dataSource = self
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let VCIndex = VCArray.firstIndex(of: viewController as! UITableViewController) else {return nil}
    return VCIndex < 1 ? nil : VCArray[VCIndex - 1]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let VCIndex = VCArray.firstIndex(of: viewController as! UITableViewController) else {return nil}
    let nextIndex = VCIndex + 1
    return nextIndex >= VCArray.count ? nil : VCArray[nextIndex]
  }
  
}
