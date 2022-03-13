//
//  MyInfoCollectionViewCell.swift
//  MOMO
//
//  Created by abc on 2022/03/11.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import SnapKit

class MyInfoCollectionViewCell: UICollectionViewCell {
  
  //MARK: - UI
  private var firstOptionLabel: UILabel?
  private var secondOptionLabel: UILabel?
  private var thirdOptionLabel: UILabel?
  private var forthOptionLabel: UILabel?
  private var stackView: UIStackView?
  
  private func buildLabels() -> [UILabel] {
    
    let labels = [UILabel(), UILabel(), UILabel(), UILabel()]
    
    labels.forEach {
      $0.text = "TESTTESTTEST\n도레미파솔라시도"
      $0.font = .customFont(forTextStyle: .footnote)
      $0.textColor = Asset.Colors.pink4.color
      $0.numberOfLines = 0
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    self.firstOptionLabel = labels[0]
    self.secondOptionLabel = labels[1]
    self.thirdOptionLabel = labels[2]
    self.forthOptionLabel = labels[3]
   
    return labels
  }
  
  private func setupUI() {
    let labels = buildLabels()
    labels.forEach {
      makeAttributed(label: $0)
    }
    let stackView = UIStackView(arrangedSubviews: labels).then {
      $0.axis = .vertical
      $0.distribution = .equalSpacing
      $0.spacing = 20
      $0.alignment = .leading
    }
    self.stackView = stackView
    contentView.addSubview(stackView)
    contentView.backgroundColor = .white
    contentView.setRound(20)
    stackView.snp.makeConstraints { make in
      make.left.right.top.bottom.equalToSuperview().inset(20)
    }
  }
  
  private func makeAttributed(label: UILabel) {
    if let text = label.text, !text.contains("\n") {
        return
    }
    let fontSize = UIFont.customFont(forTextStyle: .caption1)
    let attributedStr = NSMutableAttributedString(string: label.text!)
    let selectedStr = label.text!.components(separatedBy: "\n")
    attributedStr.addAttribute(.font, value: fontSize, range: (label.text! as NSString).range(of: selectedStr[1]))
    label.attributedText = attributedStr
  }
  
  //MARK: - Private

  private var disposeBag = DisposeBag()

  //MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

}

extension MyInfoCollectionViewCell {
  func configure(with options: [String]?, index: Int) {
    guard let options = options else {
      return
    }
    if options.count > 3 {
      firstOptionLabel?.text = options[0]
      secondOptionLabel?.text = options[1]
      thirdOptionLabel?.text = options[2]
      forthOptionLabel?.text = options[3]
    } else {
      firstOptionLabel?.text = options[0]
      secondOptionLabel?.text = options[1]
      thirdOptionLabel?.text = options[2]
      forthOptionLabel?.isHidden = true
      forthOptionLabel?.removeFromSuperview()
    }
    
  }
}
