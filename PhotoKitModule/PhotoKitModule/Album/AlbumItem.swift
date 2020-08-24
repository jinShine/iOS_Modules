//
//  AlbumItem.swift
//  core
//
//  Created by Buzz.Kim on 2020/08/23.
//  Copyright © 2020 Stat.So. All rights reserved.
//

import Foundation
import UIKit
import Photos

public struct AlbumItem {
  var createAt: Date?
  var image: UIImage?
  var isSelected: Bool
  var selectedNumber: Int
  var mediaType: PHAssetMediaType
  var duration: Int
}
