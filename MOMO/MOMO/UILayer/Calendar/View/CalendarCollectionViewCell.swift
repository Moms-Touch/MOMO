//
//  CalendarCollectionViewCell.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/24.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

class CalendarCollectionViewCell: UICollectionViewCell {
    
  private let numberLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    $0.textColor = .label
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(numberLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
}
