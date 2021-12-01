//
//  AlertTableViewCell.swift
//  MOMO
//
//  Created by abc on 2021/11/30.
//

import UIKit
import SnapKit

enum AlertType: String {
  case alert
  case message
}

struct SimpleAlertModel {
  let title: String
  let alertType: AlertType
  let content: String
}

class AlertTableViewCell: UITableViewCell, AlertContainer {
  
  var note: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    label.textColor = Asset.Colors._71.color
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  //Data를 받은다음에 title, alertType, content에 넣기
  var data: SimpleAlertModel? {
    didSet {
      contentChange()
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func setupUI() {
    contentView.backgroundColor = Asset.Colors.pink5.color.withAlphaComponent(0.3)
    contentView.addSubview(note)
    note.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.right.equalToSuperview().inset(20)
      make.left.equalToSuperview().offset(20)
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
