//
//  PolicyTableViewCell.swift
//  MOMO
//
//  Created by 오승기 on 2021/12/27.
//

import UIKit

class PolicyTableViewCell: UITableViewCell, NibInstantiatable {
    
    static var identifier = String(describing: PolicyTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
