//
//  AlbumInteractor.swift
//  core
//
//  Created by Buzz.Kim on 2020/08/21.
//  Copyright © 2020 Stat.So. All rights reserved.
//

import Foundation
import RxSwift

public protocol AlbumInteractorProtocol {
  
  func startCachingImages(indexPathList: [IndexPath]) -> Completable
  func stopCachingImages(indexPathList: [IndexPath]) -> Completable
  func fetchAlbumItemList(beginIndex: Int, endIndex: Int) -> Single<[AlbumItem]>
  func fetchAlbumVideoList(beginIndex: Int, endIndex: Int) -> Single<[AlbumItem]>
  func fetchAlbumImageList(beginIndex: Int, endIndex: Int) -> Single<[AlbumItem]>
}

public class AlbumInteractor: AlbumInteractorProtocol {

  public let albumManager: AlbumManagerProtocol
  
  public init(albumManager: AlbumManagerProtocol = AlbumManager()) {
    self.albumManager = albumManager
  }
  
  public func startCachingImages(indexPathList: [IndexPath]) -> Completable {
    return albumManager.startCachingImages(indexPathList: indexPathList)
  }
  
  public func stopCachingImages(indexPathList: [IndexPath]) -> Completable {
    return albumManager.stopCachingImages(indexPathList: indexPathList)
  }
  
  public func fetchAlbumItemList(beginIndex: Int, endIndex: Int) -> Single<[AlbumItem]> {
    return albumManager.fetchAlbumItemList(beginIndex: beginIndex, endIndex: endIndex)
  }

  public func fetchAlbumVideoList(beginIndex: Int, endIndex: Int) -> Single<[AlbumItem]> {
    return albumManager.fetchAlbumVideoList(beginIndex: beginIndex, endIndex: endIndex)
  }
  
  public func fetchAlbumImageList(beginIndex: Int, endIndex: Int) -> Single<[AlbumItem]> {
    return albumManager.fetchAlbumImageList(beginIndex: beginIndex, endIndex: endIndex)
  }
  
}
