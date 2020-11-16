//
//  ContentTableViewCell.swift
//  iCloud_Tutorial
//
//  Created by Buzz.Kim on 2020/11/16.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var contentImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
