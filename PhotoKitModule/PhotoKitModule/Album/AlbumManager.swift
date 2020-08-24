//
//  PhotoManager.swift
//  core
//
//  Created by Buzz.Kim on 2020/08/21.
//  Copyright © 2020 Stat.So. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Photos

public protocol AlbumManagerProtocol {
  
  func startCachingImages(indexPathList: [IndexPath]) -> Completable
  func stopCachingImages(indexPathList: [IndexPath]) -> Completable
  func fetchAlbumItemList(beginIndex: Int, endIndex: Int) -> Single<[AlbumItem]>
  func fetchAlbumVideoList(beginIndex: Int, endIndex: Int) -> Single<[AlbumItem]>
  func fetchAlbumImageList(beginIndex: Int, endIndex: Int) -> Single<[AlbumItem]>
}

public class AlbumManager: AlbumManagerProtocol {
  
  let cachingImageManager = PHCachingImageManager()
  var albumItemList: [AlbumItem] = []
  var albumAssetList: [PHAsset] = []
  let targetSize = CGSize(width: 500, height: 500)
  
  let option: PHImageRequestOptions = {
    let option = PHImageRequestOptions()
    option.isSynchronous = true
    return option
  }()
  
  public init() { }
  
  private func defaultFetchOptions() -> PHFetchOptions {
    let fetchOptions = PHFetchOptions()
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    fetchOptions.sortDescriptors = [sortDescriptor]
    return fetchOptions
  }
  
  public func startCachingImages(indexPathList: [IndexPath]) -> Completable {
    return Completable.create { completable -> Disposable in
      let allPhotos = PHAsset.fetchAssets(with: self.defaultFetchOptions())
      
      let assetList = indexPathList.map { allPhotos.object(at: $0.item) }
      
      self.cachingImageManager.startCachingImages(for: assetList, targetSize: self.targetSize, contentMode: .aspectFill, options: self.option)
      
      completable(.completed)
      
      return Disposables.create()
    }
  }
  
  public func stopCachingImages(indexPathList: [IndexPath]) -> Completable {
    return Completable.create { completable -> Disposable in
      let allPhotos = PHAsset.fetchAssets(with: self.defaultFetchOptions())
      
      let assetList = indexPathList.map { allPhotos.object(at: $0.item) }
      
      self.cachingImageManager.stopCachingImages(for: assetList, targetSize: self.targetSize, contentMode: .aspectFill, options: self.option)
      
      completable(.completed)
      
      return Disposables.create()
    }
  }
  
  public func fetchAlbumItemList(beginIndex: Int, endIndex: Int) -> Single<[AlbumItem]> {
    return Single.create { (single) -> Disposable in

      let allPhotos = PHAsset.fetchAssets(with: self.defaultFetchOptions())
      
      let indexSet: IndexSet
      
      if endIndex >= allPhotos.count {
        indexSet = IndexSet(Array(beginIndex..<allPhotos.count))
      } else {
        indexSet = IndexSet(Array(beginIndex..<endIndex))
      }
      
      allPhotos.enumerateObjects(at: indexSet, options: .concurrent) { (asset, count, stop) in
        self.cachingImageManager.requestImage(for: asset, targetSize: self.targetSize, contentMode: .aspectFit, options: self.option) { (image, info) in
          
          let albumItem = AlbumItem(
            createAt: asset.creationDate,
            image: image,
            isSelected: false,
            selectedNumber: 0,
            mediaType: asset.mediaType,
            duration: Int(round(asset.duration))
          )
          
          self.albumItemList.append(albumItem)
        }
        
      }
      
      single(.success(self.albumItemList))
      
      return Disposables.create()
    }
    
  }
  
  public func fetchAlbumVideoList(beginIndex: Int, endIndex: Int) -> Single<[AlbumItem]> {
    return Single.create { (single) -> Disposable in

      let allVideos = PHAsset.fetchAssets(with: .video, options: self.defaultFetchOptions())
      
      let indexSet: IndexSet
      
      if endIndex >= allVideos.count {
        indexSet = IndexSet(Array(beginIndex..<allVideos.count))
      } else {
        indexSet = IndexSet(Array(beginIndex..<endIndex))
      }
      
      allVideos.enumerateObjects(at: indexSet, options: .concurrent) { (asset, count, stop) in
        self.cachingImageManager.requestImage(for: asset, targetSize: self.targetSize, contentMode: .aspectFit, options: self.option) { (image, info) in
          
          let albumItem = AlbumItem(
            createAt: asset.creationDate,
            image: image,
            isSelected: false,
            selectedNumber: 0,
            mediaType: asset.mediaType,
            duration: Int(round(asset.duration))
          )
          
          self.albumItemList.append(albumItem)
        }
        
      }
      
      single(.success(self.albumItemList))
      
      return Disposables.create()
    }
  }
  
  public func fetchAlbumImageList(beginIndex: Int, endIndex: Int) -> Single<[AlbumItem]> {
    return Single.create { (single) -> Disposable in
      
      let allImages = PHAsset.fetchAssets(with: .image, options: self.defaultFetchOptions())
      
      let indexSet: IndexSet
      
      if endIndex >= allImages.count {
        indexSet = IndexSet(Array(beginIndex..<allImages.count))
      } else {
        indexSet = IndexSet(Array(beginIndex..<endIndex))
      }
      
      allImages.enumerateObjects(at: indexSet, options: .concurrent) { (asset, count, stop) in
        self.cachingImageManager.requestImage(for: asset, targetSize: self.targetSize, contentMode: .aspectFit, options: self.option) { (image, info) in
          
          let albumItem = AlbumItem(
            createAt: asset.creationDate,
            image: image,
            isSelected: false,
            selectedNumber: 0,
            mediaType: asset.mediaType,
            duration: Int(round(asset.duration))
          )
          
          self.albumItemList.append(albumItem)
        }
        
      }
      
      single(.success(self.albumItemList))
      
      return Disposables.create()
    }
  }
  
}
