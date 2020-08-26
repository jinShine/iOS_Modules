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
