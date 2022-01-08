//
//  BannerCell.swift
//  MOMO
//
//  Created by abc on 2021/12/11.
//

import UIKit

class BannerCell: UICollectionViewCell {
  
  internal var data: NoticeData? {
    didSet {
      titleLabel.text = data?.title ?? "공지사항"
    }
  }
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.customFont(forTextStyle: .caption1)
    label.textColor = .label
    label.numberOfLines = 0
    label.text = "[필독] 임산부가\n 주의해야할 약 10가지"
    label.accessibilityHint = "모모 공지사항입니다."
    label.accessibilityTraits = .link
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupLayout()
  }
  
  private func setupLayout() {
    contentView.addSubview(titleLabel)
    contentView.backgroundColor = Asset.Colors.fa.color.withAlphaComponent(0.5)
    titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
  }
}
