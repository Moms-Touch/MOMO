//
//  QuestionTableViewCell.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/28.
//

import UIKit

class QuestionTableViewCell: UITableViewCell, NibInstantiatable {
  
  static var identifier = String(describing: QuestionTableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
