//
//  AlbumItemCell.swift
//  core
//
//  Created by Buzz.Kim on 2020/08/23.
//  Copyright © 2020 Stat.So. All rights reserved.
//

import Foundation
import UIKit

class AlbumItemCell: BaseCollectionViewCell {

  let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  let numberLabel = UILabel().then {
    $0.layer.cornerRadius = 12
    $0.layer.masksToBounds = true
    $0.backgroundColor = UIColor.colorBgBrand
    $0.textAlignment = .center
  }
  
  let durationLabel = UILabel()
  
  lazy var selectedView = UIView().then { container in
    container.backgroundColor = UIColor.colorTextDarkSecondary
    container.layer.borderColor = UIColor.colorBgBrand?.cgColor
    container.layer.borderWidth = 2
    
    numberLabel
      .add(to: container)
      .snp.makeConstraints {
        $0.top.equalToSuperview().offset(8)
        $0.trailing.equalToSuperview().offset(-8)
        $0.size.equalTo(24)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    imageView.image = nil
    numberLabel.text = nil
    durationLabel.text = nil
    selectedView.isHidden = true
  }
  
  private func setupUI() {
    
    imageView
      .add(to: contentView)
      .snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    
    selectedView
      .add(to: imageView)
      .snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    
    durationLabel
      .add(to: contentView)
      .snp.makeConstraints {
        $0.leading.equalToSuperview().offset(8)
        $0.bottom.equalToSuperview().offset(-8)
    }
  }
  
  func configure(with item: AlbumItem) {
    self.selectedView.isHidden = !item.isSelected
    self.imageView.image = item.image
    self.numberLabel.attributedText = TextStyle
      .fontHeadline_2sbColorTextLightPrimaryCenter
      .createAttributedString("\(item.selectedNumber)")
    
    if item.mediaType == .video || item.mediaType == .audio {
      self.durationLabel.attributedText = TextStyle
        .fontCaption_1sbColorTextLightPrimaryCenter
        .createAttributedString(item.duration.toMinute)
    }
  }

}
