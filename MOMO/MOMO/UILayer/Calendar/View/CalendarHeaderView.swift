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


class CalendarHeaderView: UIView, ViewModelBindableType {
  
  private let monthLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 22, weight: .bold)
    $0.text = "Month"
    $0.accessibilityTraits = .header
    $0.isAccessibilityElement = true
  }
  
  private let closeButton = UIButton(type: .custom).then {
    $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .label
    $0.contentMode = .scaleAspectFill
    $0.isAccessibilityElement = true
    $0.accessibilityLabel = "closeButton"
  }
  
  private var dayLabels = [UILabel]()
  
  private let dayOfWeekStackView = UIStackView().then { $0.distribution = .fillEqually
  }
      
  private let separatorView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  var viewModel: CalendarHeaderViewModel
  private var disposeBag = DisposeBag()
  
  func bindViewModel() {
    
    viewModel.output.month
      .drive(monthLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.output.dayLetter
      .filter { $1 != "" }
      .drive(onNext: { [unowned self] in
        self.dayLabels[$0].text = $1
      })
      .disposed(by: disposeBag)
    
  }
  
  init(viewModel: CalendarHeaderViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    self.bindViewModel()
    
    self.translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .clear
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
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        if dayNumber == 1 {
          $0.textColor = Asset.Colors.pink4.color
        } else {
          $0.textColor = Asset.Colors._71.color
        }
        $0.textAlignment = .center
        $0.text = "\(dayNumber)"
      }
      
      dayLabel.isAccessibilityElement = false
      dayOfWeekStackView.addArrangedSubview(dayLabel)
      dayLabels.append(dayLabel)
    }
    
    dayLabels.forEach {
      self.viewModel.input.dayNumber
        .onNext(Int($0.text!)!)
//      print()
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    monthLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(30)
      make.centerX.equalToSuperview()
    }
    
    closeButton.snp.makeConstraints { make in
      make.centerY.equalTo(monthLabel)
      make.width.height.equalTo(28)
      make.leading.equalToSuperview().inset(16)
    }
    
    dayOfWeekStackView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.bottom.equalTo(separatorView.snp.bottom).inset(5)
    }
    
    separatorView.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.height.equalTo(1)
    }
    
  }
      
}
