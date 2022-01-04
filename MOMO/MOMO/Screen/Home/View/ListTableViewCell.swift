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
  @IBOutlet weak var thumbnailImageView: UIImageView!
  
  internal var data: simpleContent? {
    
    didSet {
      
      titleLabel.text = data?.title ?? "준비중입니다."
      if let title = data?.title {
        if title == "" {
          titleLabel.text = "준비중입니다."
        }
      }
      
      organizationLabel.text = data?.author ?? "모모관리자"
      
      dateLabel.text = (data?.createdAt ?? "").trimStringDate()
      
      if let author = data?.author, author.contains("여성가족부") == true {
        thumbnailImageView.image = UIImage(named: "governmentLogo")!
        
        return
      }
      
      if let author = data?.author, author.contains("인트리") == true {
        thumbnailImageView.image = UIImage(named: "인트리")!
        
        return
      }
      
      if let author = data?.author, author.contains("한국미혼모지원네트워크") == true {
        thumbnailImageView.image = UIImage(named: "한국미혼모지원네트워크")!
        
        return
      }
      
      if let author = data?.author, author.contains("러브더월드") == true {
        thumbnailImageView.image = UIImage(named: "러브더월드")!
        
        return
      }
      
      if let author = data?.author, author.contains("동감") == true {
        thumbnailImageView.image = UIImage(named: "동감")!
        
        return
      }
      
      if let author = data?.author, author.contains("한국미혼모가족협회") == true {
        thumbnailImageView.image = UIImage(named: "한국미혼모가족협회")!
        
        return
      }
      
      guard let thumbnailImageUrl = data?.thumbnailImageUrl else {
        thumbnailImageView.image = UIImage(named: "Logo")!
        return
      }
      thumbnailImageView.setImage(with: thumbnailImageUrl)
      
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
