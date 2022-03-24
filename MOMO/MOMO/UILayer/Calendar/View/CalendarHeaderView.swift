//
//  CalendarHeaderView.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa


class CalendarHeaderView: UIView {
  
  let monthLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 26, weight: .bold)
    $0.text = "Month"
    $0.accessibilityTraits = .header
    $0.isAccessibilityElement = true
  }
  
  let closeButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    $0.contentMode = .scaleAspectFill
    $0.isAccessibilityElement = true
    $0.accessibilityLabel = "closeButton"
  }
  
  let dayOfWeekStackView = UIStackView().then { $0.distribution = .fillEqually
  }
      
  let separatorView = UIView().then {
    $0.backgroundColor = UIColor.label.withAlphaComponent(0.2)
  }
  
  init() {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemGroupedBackground
    layer.maskedCorners = [
      .layerMinXMinYCorner,
      .layerMaxXMinYCorner
    ]
    layer.cornerRadius = 15
    layer.cornerCurve = .continuous
    
    addSubview(monthLabel)
    addSubview(closeButton)
    addSubview(dayOfWeekStackView)
    addSubview(separatorView)
    
    for dayNumber in 1...7 {
      let dayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
        $0.text = ""
      }
      
      dayLabel.isAccessibilityElement = false
      dayOfWeekStackView.addArrangedSubview(dayLabel)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    monthLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(15)
      make.centerX.equalToSuperview()
    }
    
    closeButton.snp.makeConstraints { make in
      make.centerY.equalTo(monthLabel)
      make.leading.equalToSuperview().inset(16)
    }
    
    dayOfWeekStackView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.bottom.equalTo(separatorView.snp.bottom).inset(-5)
    }
    
    separatorView.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.height.equalTo(1)
    }
    
  }
      
}
