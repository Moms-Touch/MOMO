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

class CalendarCollectionViewCell: UICollectionViewCell{
  
  private let numberLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    $0.textColor = Asset.Colors._45.color
  }
  
  private let emojiImageView = UIImageView().then {
    $0.image = nil
    $0.contentMode = .scaleAspectFill
    $0.isUserInteractionEnabled = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .clear
    contentView.addSubview(numberLabel)
    contentView.addSubview(emojiImageView)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    numberLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(4)
      make.left.equalToSuperview().inset(4)
    }
    
    emojiImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(5)
      make.height.width.equalToSuperview().multipliedBy(0.6)
    }
    
  }
  
}

extension CalendarCollectionViewCell {
  func configure(day: Day, index: Int) {
    
    for layer in contentView.layer.sublayers ?? []{
         if layer.name == "border" {
              layer.removeFromSuperlayer()
         }
     }
    
    if index % 7 == 0 {
      self.numberLabel.textColor = Asset.Colors.pink4.color
    } else {
      self.numberLabel.textColor = Asset.Colors._45.color
    }
    
    if index < 28 {
      if index % 7 == 6 {
        contentView.addBorder([.bottom], color: Asset.Colors.pink4.color, width: 1)
      } else {
        contentView.addBorder([.bottom, .right], color: Asset.Colors.pink4.color, width: 1)
      }
    } else {
      if index % 7 == 6 {
        contentView.addBorder([.bottom], color: Asset.Colors.pink4.color, width: 1)
      } else {
        contentView.addBorder([.right], color: Asset.Colors.pink4.color, width: 1)
      }
    }
    
    self.numberLabel.text = day.number
    self.emojiImageView.image = day.mood.image
    
  }
}
