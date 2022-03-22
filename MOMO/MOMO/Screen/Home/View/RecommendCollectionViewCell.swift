//
//  RecommendCollectionViewCell.swift
//  MOMO
//
//  Created by abc on 2021/11/25.
//

import UIKit
import Then
import SnapKit
import RxSwift

class RecommendCollectionViewCell: UICollectionViewCell {
  
  lazy var thumbNailImageView: UIImageView = {
    let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 103, height: 103))
    imageview.isUserInteractionEnabled = true
    imageview.image = UIImage(named: "mascot")
    imageview.setRound(5)
    imageview.translatesAutoresizingMaskIntoConstraints = false
    return imageview
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.customFont(forTextStyle: .caption2)
    label.textColor = .label
    label.numberOfLines = 0
    label.text = "[필독] 임산부가\n 주의해야할 약 10가지"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.setRound(5)
    contentView.addSubview(titleLabel)
    contentView.addSubview(thumbNailImageView)
    thumbNailImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    thumbNailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    thumbNailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    thumbNailImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.7).isActive = true
    titleLabel.topAnchor.constraint(equalTo: thumbNailImageView.bottomAnchor, constant: 10).isActive = true
    
    
    titleLabel.leadingAnchor.constraint(equalTo: thumbNailImageView.leadingAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: thumbNailImageView.trailingAnchor).isActive = true
    
    contentView.isAccessibilityElement = false
    thumbNailImageView.isAccessibilityElement = false
    titleLabel.isAccessibilityElement = true

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
}


extension RecommendCollectionViewCell {
  func configure(data: InfoData) {
    if let thumbnailImageUrl = data.thumbnailImageUrl {
      thumbNailImageView.setImage(with:thumbnailImageUrl)
      titleLabel.text = data.title
    } else {
      thumbNailImageView.image = UIImage(named: "mascot")
      titleLabel.text = data.title
    }
  }
}
