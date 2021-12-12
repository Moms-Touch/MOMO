//
//  ListTableViewCell.swift
//  MOMO
//
//  Created by abc on 2021/11/15.
//

import UIKit

class ListTableViewCell: UITableViewCell, NibLoadableView, simpleContentContainer {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var organizationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
    
  internal var data: simpleContent? {
    didSet {
      titleLabel.text = data?.title
      organizationLabel.text = data?.author ?? "모모관리자"
      dateLabel.text = data?.createdAt
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
}
