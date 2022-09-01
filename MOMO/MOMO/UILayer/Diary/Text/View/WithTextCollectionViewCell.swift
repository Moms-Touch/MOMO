//
//  WithTextCollectionViewCell.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/27.
//

import UIKit

import RxSwift
import RxCocoa

class WithTextCollectionViewCell: UICollectionViewCell {
  
  let questionLabel = UILabel().then {
    $0.font = UIFont.customFont(forTextStyle: .title3)
    $0.text = ""
    $0.textColor = .label
  }
  
  let answerTextView = UITextView().then {
    $0.backgroundColor = .clear
    $0.textColor = .label
    $0.font = UIFont.customFont(forTextStyle: .body)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  let indexLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 18, weight: .bold)
    $0.textColor = .label
    $0.text = "1/3"
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var viewModel: WithTextCellViewModel?
  var showViewModel: ReadTextCellViewModel?
  var bottomConstriant: NSLayoutConstraint?
  
  func bindViewModel() {

    if let viewModel = viewModel {
      // MARK: - Input
      answerTextView.rx.text
        .compactMap { $0 }
        .bind(to: viewModel.input.content)
        .disposed(by: disposeBag)
    
      // MARK: - Output
      viewModel.output.question
        .drive(questionLabel.rx.text)
        .disposed(by: disposeBag)
      
      viewModel.output.index
        .drive(indexLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
    // MARK: - ShowMode
    
    if let viewModel = showViewModel {
      
      viewModel.output.answer
        .drive(onNext: { [weak self] in
          guard let self = self else {return}
          self.answerTextView.text = $0
        })
        .disposed(by: disposeBag)
      
      viewModel.output.question
        .drive(questionLabel.rx.text)
        .disposed(by: disposeBag)
      
      viewModel.output.index
        .drive(indexLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
  }
  
  private var disposeBag = DisposeBag()
  
  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  override func layoutSubviews() {
    answerTextView.addDoneButton(title: "완료", target: self, selector: #selector(tapDone))
    
    contentView.addSubview(questionLabel)
    contentView.addSubview(indexLabel)
    contentView.addSubview(answerTextView)
    
    
    questionLabel.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(16)
      make.top.equalToSuperview()
    }
    
    answerTextView.snp.makeConstraints { make in
      make.top.equalTo(questionLabel.snp.bottom).offset(10)
      make.left.right.equalToSuperview().inset(16)
    }
    
    bottomConstriant = answerTextView.bottomAnchor.constraint(equalTo: indexLabel.topAnchor)
    bottomConstriant?.isActive = true
    
    indexLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(8)
    }
    
  }
  
  @objc func tapDone(sender: Any) {
    self.answerTextView.endEditing(true)
  }
}

extension WithTextCollectionViewCell {
  func configure(with viewModel: WithTextCellViewModel) {
    self.viewModel = viewModel
    bindViewModel()
  }
  
  func configure(with viewModel: ReadTextCellViewModel) {
    self.showViewModel = viewModel
    self.answerTextView.isSelectable = false
    bindViewModel()
  }
  
}
