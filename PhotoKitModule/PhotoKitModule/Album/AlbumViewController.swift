//
//  AlbumViewController.swift
//  PhotoKitModule
//
//  Created by Buzz.Kim on 2020/09/13.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit
import Photos

class AlbumViewController: UIViewController {
  @IBOutlet fileprivate weak var collectionView: UICollectionView!
  
  fileprivate let kCellReuseIdentifier = "Cell"
  fileprivate let kColumnCnt: Int = 3
  fileprivate let kCellSpacing: CGFloat = 2
  fileprivate var fetchResult: PHFetchResult<PHAsset>!
  fileprivate var imageManager = PHCachingImageManager()
  fileprivate var targetSize = CGSize.zero
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initView()
    loadPhotos()
  }
}

extension AlbumViewController {
  func initView() {
    let imgWidth = (collectionView.frame.width - (kCellSpacing * (CGFloat(kColumnCnt) - 1))) / CGFloat(kColumnCnt)
    targetSize = CGSize(width: imgWidth, height: imgWidth)
    
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = targetSize
    layout.minimumInteritemSpacing = kCellSpacing
    layout.minimumLineSpacing = kCellSpacing
    collectionView.collectionViewLayout = layout
    
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellReuseIdentifier)
  }
  
  func loadPhotos() {
    let options = PHFetchOptions()
    options.sortDescriptors = [
      NSSortDescriptor(key: "creationDate", ascending: false)
    ]
    fetchResult = PHAsset.fetchAssets(with: .image, options: options)
  }
}

extension AlbumViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuseIdentifier, for: indexPath)
    let photoAsset = fetchResult.object(at: indexPath.item)
    imageManager.requestImage(for: photoAsset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, info) -> Void in
      let imageView = UIImageView(image: image)
      imageView.frame.size = cell.frame.size
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      cell.contentView.addSubview(imageView)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return fetchResult.count
  }
}

extension AlbumViewController: UICollectionViewDataSourcePrefetching {
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    DispatchQueue.main.async {
      self.imageManager.startCachingImages(for: indexPaths.map{ self.fetchResult.object(at: $0.item) }, targetSize: self.targetSize, contentMode: .aspectFill, options: nil)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    DispatchQueue.main.async {
      self.imageManager.stopCachingImages(for: indexPaths.map{ self.fetchResult.object(at: $0.item) }, targetSize: self.targetSize, contentMode: .aspectFill, options: nil)
    }
  }
}

extension AlbumViewController: UICollectionViewDelegate {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
    return targetSize
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let photoAsset = fetchResult.object(at: indexPath.item)
    print(photoAsset.description)
  }
}
