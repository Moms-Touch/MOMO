//
//  ListTableViewCell.swift
//  MOMO
//
//  Created by abc on 2021/11/15.
//

import UIKit

class ListTableViewCell: UITableViewCell, NibLoadableView, simpleContentContainer {
  
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.headLineStyle()
    }
  }
  @IBOutlet weak var organizationLabel: UILabel! {
    didSet {
      organizationLabel.subHeadLineStyle()
    }
  }
  @IBOutlet weak var dateLabel: UILabel! {
    didSet {
      dateLabel.subHeadLineStyle()
    }
  }
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
        thumbnailImageView.image = UIImage(named: "intree")!
        
        return
      }
      
      if let author = data?.author, author.contains("한국미혼모지원네트워크") == true {
        thumbnailImageView.image = UIImage(named: "koreaSinglemomNetwork")!
        
        return
      }
      
      if let author = data?.author, author.contains("러브더월드") == true {
        thumbnailImageView.image = UIImage(named: "loveTheWorld")!
        
        return
      }
      
      if let author = data?.author, author.contains("동감") == true {
        thumbnailImageView.image = UIImage(named: "dongkam")!
        
        return
      }
      
      if let author = data?.author, author.contains("한국미혼모가족협회") == true {
        thumbnailImageView.image = UIImage(named: "singlemomAssoication")!
        
        return
      }
      guard let thumbnailImageUrl = data?.thumbnailImageUrl else {
        thumbnailImageView.image = UIImage(named: "Logo")!
        return
      }
      thumbnailImageView.setImage(with: thumbnailImageUrl)
      
    }
  }
  
  private func setAccessability(){
    self.isAccessibilityElement = false
    let accessabilityList = [titleLabel, organizationLabel, dateLabel]
    accessabilityList.compactMap{$0}.forEach({ label in
      label.isAccessibilityElement = true
    })
    thumbnailImageView.isAccessibilityElement = false
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setAccessability()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
}
