//
//  PhotoCollectionViewCell.swift
//  PhotoKitModule
//
//  Created by buzz on 2021/05/09.
//  Copyright © 2021 jinnify. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

  @IBOutlet var mainImageView: UIImageView!

  let cellSize: CGSize = {
    CGSize(width: 100.0, height: 100.0)
  }()
}
