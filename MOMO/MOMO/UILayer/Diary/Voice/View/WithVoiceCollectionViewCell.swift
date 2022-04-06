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
  
  let durationLabel = UILabel().then {
    $0.isHidden = true
    $0.text = ""
    $0.textColor = .label
    $0.numberOfLines = 1
  }
  
  let recordButton = UIButton().then {
    $0.setImage(UIImage(named: "micOn"), for: .normal)
  }
  
  override func layoutSubviews() {
    
    contentView.addSubview(questionLabel)
    contentView.addSubview(recordingAnimationView)
    contentView.addSubview(recordButton)
    contentView.addSubview(durationLabel)
    
    questionLabel.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(16)
      make.top.equalToSuperview()
    }
    
    recordButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.height.width.equalTo(contentView.snp.height).multipliedBy(0.3)
      make.centerY.equalToSuperview().offset(questionLabel.frame.height)
    }
    
    durationLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(recordButton.snp.bottom).offset(5)
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
  var showViewModel: ReadVoiceCellViewModel?
  
  func bindViewModel() {
    if let viewModel = viewModel {
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
    
    if let viewModel = showViewModel {
      
      durationLabel.isHidden = false
      
      recordButton.rx.tap
        .bind(to: viewModel.input.playerButtonClicked)
        .disposed(by: disposeBag)
      
      viewModel.output.question
        .map { "Q. \($0)"}
        .drive(questionLabel.rx.text)
        .disposed(by: disposeBag)
      
      viewModel.output.currentStatus
        .debug()
        .drive(onNext: { [weak self] status in
          guard let self = self else {return}
          switch status {
          case .notStarted:
            self.recordButton.setImage(UIImage(named: "play"), for: .normal)
          case .nowPlaying:
            self.recordButton.setImage(UIImage(named: "pause"), for: .normal)
          case .pause:
            self.recordButton.setImage(UIImage(named: "play"), for: .normal)
          case .stop:
            self.recordButton.setImage(UIImage(named: "play"), for: .normal)
          }
        })
        .disposed(by: disposeBag)
      
      viewModel.output.playerTimer
        .map { "\($0.1) / \($0.0)"}
        .drive(durationLabel.rx.text)
        .disposed(by: disposeBag)
      
    }
    
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
  
  func configure(with viewModel: ReadVoiceCellViewModel) {
    self.showViewModel = viewModel
    self.bindViewModel()
  }
  
}
