//
//  MomoPagable.swift
//  MOMO
//
//  Created by abc on 2021/11/29.
//

import Foundation
import UIKit

protocol MomoPageable: AnyObject {
  var segmentedControl: UISegmentedControl { get }
  var segmentedControlTextColor: (selected: ColorAsset.Color, unselected: ColorAsset.Color) { get }
  var segmentedConrolBackgroundColor: UIColor { get }
}
extension MomoPageable {
  
  func removeBorder() {
    let colorImage = UIImage.colorImage(color: segmentedConrolBackgroundColor.cgColor, size: segmentedControl.bounds.size)
    segmentedControl.setBackgroundImage(colorImage, for: .normal, barMetrics: .default)
    segmentedControl.setBackgroundImage(colorImage, for: .selected, barMetrics: .default)
    segmentedControl.setBackgroundImage(colorImage, for: .highlighted, barMetrics: .default)

    let devider = UIImage.colorImage(color: UIColor.white.cgColor, size: CGSize(width: 1.0, height: segmentedControl.bounds.size.height))
    segmentedControl.setDividerImage(devider, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)], for: .selected)
  }
  
  func setTextColor() {
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : segmentedControlTextColor.selected, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)], for: .selected)
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : segmentedControlTextColor.unselected, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .bold)], for: .normal)
  }
  
  func setBorder(color: UIColor) {
    segmentedControl.addBorder([.bottom], color: color, width: 3)
  }
  
  func setupSegmentedControl() {
    removeBorder()
    setTextColor()
  }
  
}
