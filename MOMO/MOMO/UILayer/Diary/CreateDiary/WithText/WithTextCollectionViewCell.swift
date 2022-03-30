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
  private var bottomConstriant: NSLayoutConstraint?
  
  func bindViewModel() {
    
    guard let viewModel = viewModel else {
      return
    }
    
    // MARK: - Input
    answerTextView.rx.text
      .compactMap { $0 }
      .bind(to: viewModel.input.content)
      .disposed(by: disposeBag)
    
    keyboardHeight()
      .withUnretained(self)
      .bind(onNext: { cell, height in
        cell.bottomConstriant?.isActive = false
        cell.bottomConstriant = cell.answerTextView.bottomAnchor.constraint(equalTo: cell.indexLabel.topAnchor, constant: -height)
        cell.bottomConstriant?.isActive = true
      })
      .disposed(by: disposeBag)
    
//    Observable.combineLatest(answerTextView.rx.text, keyboardHeight())
//      .bind { [weak self] text, keyboardHeight in
//        guard let self = self else {return}
//        let caret = self.answerTextView.caretRect(for: self.answerTextView.selectedTextRange!.start)
//        let keyboardTopBorder = self.answerTextView.bounds.size.height - keyboardHeight
//        if caret.origin.y < keyboardTopBorder {
//          self.answerTextView.scrollRectToVisible(caret, animated: true)
//        }
//      }
//      .disposed(by: disposeBag)
      
    
    // MARK: - Output
    viewModel.output.question
      .drive(questionLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.output.index
      .drive(indexLabel.rx.text)
      .disposed(by: disposeBag)
    
  }
  
  private var disposeBag = DisposeBag()
  
  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  override func layoutSubviews() {
    answerTextView.addDoneButton(title: "완료", target: self, selector: #selector(tapDone))
    contentView.addSubview(questionLabel)
    contentView.addSubview(answerTextView)
    contentView.addSubview(indexLabel)
    
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
}

extension WithTextCollectionViewCell {
  func keyboardHeight() -> Observable<CGFloat> {
    return Observable
      .from([
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
          .map { notification -> CGFloat in
            (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
          },
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
          .map { _ -> CGFloat in
            0
          }
      ])
      .merge()
  }
}

