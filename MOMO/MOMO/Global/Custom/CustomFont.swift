//
//  CustomFont.swift
//  MOMO
//
//  Created by Cashwalk on 2022/01/08.
//

import Foundation
import UIKit

struct CustomFont {
  
  static let customFonts: [UIFont.TextStyle: UIFont] = [
    .largeTitle: UIFont.systemFont(ofSize: 31, weight: .bold),
    .title1: UIFont.systemFont(ofSize: 20, weight: .bold),    //navigation Title
    .title2: UIFont.systemFont(ofSize: 18, weight: .bold),    // Button
//    .title3: UIFont(name: "Merriweather-Regular", size: 20)!,
//    .headline: UIFont(name: "Merriweather-Bold", size: 17)!,
//    .body: UIFont(name: "Merriweather-Regular", size: 17)!,
//    .callout: UIFont(name: "Merriweather-Regular", size: 16)!,
//    .subheadline: UIFont(name: "Merriweather-Regular", size: 15)!,
    .footnote: UIFont.systemFont(ofSize: 18, weight: .medium),      //로그인하는곳 text입력필드
//    .caption1: UIFont(name: "Merriweather-Regular", size: 12)!,
//    .caption2: UIFont(name: "Merriweather-Regular", size: 11)!
  ]
}

extension UIFont {
  class func customFont(forTextStyle style: UIFont.TextStyle) -> UIFont {
    let customFont = CustomFont.customFonts[style]!
    let metrics = UIFontMetrics(forTextStyle: style)
    let scaledFont = metrics.scaledFont(for: customFont)
    
    return scaledFont
  }
}
