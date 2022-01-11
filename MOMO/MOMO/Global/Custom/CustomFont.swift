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
    .title3: UIFont.systemFont(ofSize: 16, weight: .bold),
    .headline: UIFont.systemFont(ofSize: 14, weight: .bold), //Cell 제목
    .body: UIFont.systemFont(ofSize: 16, weight: .medium),
    .callout: UIFont.systemFont(ofSize: 20, weight: .medium),
    .subheadline: UIFont.systemFont(ofSize: 12, weight: .bold), //Cell 부제목
    .footnote: UIFont.systemFont(ofSize: 18, weight: .medium),  //로그인하는곳 text입력필드
    .caption1: UIFont.systemFont(ofSize: 12, weight: .medium), 
    .caption2: UIFont.systemFont(ofSize: 14, weight: .medium)
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
