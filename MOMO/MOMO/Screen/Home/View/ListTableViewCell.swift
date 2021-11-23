//
//  ListTableViewCell.swift
//  MOMO
//
//  Created by abc on 2021/11/15.
//

import UIKit

class ListTableViewCell: UITableViewCell, NibLoadableView {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var organizationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  private var data: SimpleListModel? {
    didSet {
      titleLabel.text = data?.title
      organizationLabel.text = data?.organization
      dateLabel.text = data?.date.toString()
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
