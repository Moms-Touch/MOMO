//
//  WithVoiceCollectionViewCell.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/31.
//

import UIKit

import RxSwift
import RxCocoa
import Lottie

class WithVoiceCollectionViewCell: UICollectionViewCell {
  
  // MARK: - UI
  
  let recordingAnimationView = AnimationView(name: "recordingAnimation").then {
    $0.isHidden = true
    $0.loopMode = .loop
  }
  
  let questionLabel = UILabel().then {
    $0.font = UIFont.customFont(forTextStyle: .title3)
    $0.text = ""
    $0.textColor = .label
    $0.numberOfLines = 2
  }
  
  let recordButton = UIButton().then {
    $0.setImage(UIImage(named: "micOn"), for: .normal)
  }
  
  override func layoutSubviews() {
    
    contentView.addSubview(questionLabel)
    contentView.addSubview(recordingAnimationView)
    contentView.addSubview(recordButton)
    
    questionLabel.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(16)
      make.top.equalToSuperview()
    }
    
    recordButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.height.width.equalTo(contentView.snp.height).multipliedBy(0.3)
      make.centerY.equalToSuperview().offset(questionLabel.frame.height)
    }
    
    recordingAnimationView.snp.makeConstraints { make in
      make.height.width.equalTo(contentView.snp.height).multipliedBy(0.3)
      make.center.equalTo(recordButton)
    }
    
    
  }
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  
  // MARK: - ViewModel & binding
  
  var viewModel: WithVoiceCellModel?
  
  func bindViewModel() {
    guard let viewModel = viewModel else {
      return
    }
    // MARK: - Input
    recordButton.rx.tap
      .bind(to: viewModel.input.recordButtonClicked)
      .disposed(by: disposeBag)
    
    
    // MARK: - Output
    viewModel.output.currentStatus
      .debug()
      .drive(onNext: { [unowned self] in
        self.recordButton.setImage( $0.image!, for: .normal)
        if $0 == .recording {
          self.recordingAnimationView.isHidden = false
          self.recordingAnimationView.play()
        } else {
          self.recordingAnimationView.pause()
          self.recordingAnimationView.isHidden = true
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.question
      .drive(questionLabel.rx.text)
      .disposed(by: disposeBag)
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension WithVoiceCollectionViewCell {
  func configure(with viewModel: WithVoiceCellModel) {
    self.viewModel = viewModel
    self.bindViewModel()
  }
}
