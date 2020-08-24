//
//  ViewController.swift
//  PhotoKitModule
//
//  Created by Buzz.Kim on 2020/08/21.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit
import Photos


class PhotoManager {
  
  let imageManager: PHImageManager

  let targetSize = CGSize(width: 145, height: 145)
  
  let option: PHImageRequestOptions = {
    let option = PHImageRequestOptions()
    option.isSynchronous = true
    return option
  }()

  init() {
    self.imageManager = PHImageManager()
  }

  private func defaultFetchOptions() -> PHFetchOptions {
    let fetchOptions = PHFetchOptions()
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    fetchOptions.sortDescriptors = [sortDescriptor]
    return fetchOptions
  }
  
  func fetchItemAll() {
    let allPhotos = PHAsset.fetchAssets(with: defaultFetchOptions())
    
    DispatchQueue.global(qos: .background).async {
      allPhotos.enumerateObjects { (asset, count, stop) in
        self.imageManager.requestImage(for: asset, targetSize: self.targetSize, contentMode: .aspectFit, options: self.option) { (image, info) in
          if let image = image {
            
          }
        }
      }
    }
  }
  
  func fetchVideos() {
    let allVideos = PHAsset.fetchAssets(with: .video, options: defaultFetchOptions())
  }
  
  func fetchImages() {
    let allImages = PHAsset.fetchAssets(with: .image, options: defaultFetchOptions())
  }
  
}

class ViewController: UIViewController {

  var photoList: PHFetchResult<PHAsset>?
  let imageManager = PHImageManager()
  let targetSize = CGSize(width: 145, height: 145)
  
  var imageList: [UIImage] = []
  var assetList: [PHAsset] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchImage()
    
  }
  
  private func assetsFetchOptions() -> PHFetchOptions {
      let fetchOptions = PHFetchOptions()
      fetchOptions.fetchLimit = 200
      let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
      fetchOptions.sortDescriptors = [sortDescriptor]
      return fetchOptions
  }
  
  private func fetchImage() {
    let allPhotos = PHAsset.fetchAssets(with: assetsFetchOptions())
    
    let option = PHImageRequestOptions()
    option.isSynchronous = true
    
    DispatchQueue.global(qos: .background).async {
      allPhotos.enumerateObjects { (asset, count, stop) in
        self.assetList.append(asset)
        
        self.imageManager.requestImage(for: asset, targetSize: self.targetSize, contentMode: .aspectFit, options: option) { (image, info) in
          if let image = image {
            self.imageList.append(image)
            self.assetList.append(asset)
            print("Image! :", image)
            print("Asset! :", asset)
          }
        }
      }
    }
  }

}
//
//extension ViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuseIdentifier, for: indexPath)
//        let photoAsset = fetchResult.object(at: indexPath.item)
//        imageManager.requestImage(for: photoAsset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, info) -> Void in
//            let imageView = UIImageView(image: image)
//            imageView.frame.size = cell.frame.size
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            cell.contentView.addSubview(imageView)
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return fetchResult.count
//    }
//}
//
//extension ViewController: UICollectionViewDelegate {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
//        return targetSize
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let photoAsset = fetchResult.object(at: indexPath.item)
//        print(photoAsset.description)
//    }
//}
//
//extension ViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        DispatchQueue.main.async {
//            self.imageManager.startCachingImages(for: indexPaths.map{ self.fetchResult.object(at: $0.item) }, targetSize: self.targetSize, contentMode: .aspectFill, options: nil)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//        DispatchQueue.main.async {
//            self.imageManager.stopCachingImages(for: indexPaths.map{ self.fetchResult.object(at: $0.item) }, targetSize: self.targetSize, contentMode: .aspectFill, options: nil)
//        }
//    }
//}
