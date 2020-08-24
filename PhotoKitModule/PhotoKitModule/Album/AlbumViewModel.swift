//
//  AlbumViewModel.swift
//  core
//
//  Created by Buzz.Kim on 2020/08/21.
//  Copyright © 2020 Stat.So. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class AlbumViewModel: BaseViewModel, ViewModelType {
  
  public struct Input {
    let viewWillAppearTrigger: Observable<Void>
    let didTapCellSelected: Observable<(IndexPath, AlbumItem)>
    let willDisplayCellTrigger: Observable<(UICollectionViewCell, IndexPath)>
    let prefetchItemsTrigger: Observable<[IndexPath]>
    let cancelPrefetchingTrigger: Observable<[IndexPath]>
  }
  
  public struct Output {
    let fetchPhotoItems: Driver<Void>
    let loadMore: Driver<Void>
    let updateAlbumItemList: Observable<[AlbumOfSection]>
    let startCachingImages: Driver<Void>
    let stopCachingImages: Driver<Void>
    let selectedCell: Driver<Void>
  }
  
  private let albumItemList = BehaviorRelay<[AlbumOfSection]>(value: [])
  private var selectedIndexPathList: [IndexPath] = []
  private var beginIndex: Int = 0
  private var endIndex: Int = 30
  private let albumInteractor: AlbumInteractorProtocol
  
  public init(albumInteractor: AlbumInteractorProtocol = AlbumInteractor()) {
    self.albumInteractor = albumInteractor
  }
  
  public func transform(input: Input) -> Output {
    
    let fetchPhotoItems = input.viewWillAppearTrigger
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .flatMap { self.albumInteractor.fetchAlbumItemList(beginIndex: self.beginIndex, endIndex: self.endIndex) }
      .observeOn(MainScheduler.instance)
      .map { [AlbumOfSection(model: "", items: $0)] }
      .do(onNext: { self.albumItemList.accept($0) })
      .mapToVoid()
      .asDriverOnErrorJustComplete()
    
    let loadMore = input.willDisplayCellTrigger
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .filter { $1.row == self.endIndex - 1 }
      .flatMap { cell, indexPath -> Single<[AlbumItem]> in
        self.beginIndex = self.endIndex - 1
        self.endIndex += self.endIndex
        return self.albumInteractor.fetchAlbumItemList(beginIndex: self.beginIndex, endIndex: self.endIndex)
    }
    .observeOn(MainScheduler.instance)
    .map { [AlbumOfSection(model: "", items: $0)] }
    .do(onNext: { self.albumItemList.accept($0) })
    .mapToVoid()
    .asDriverOnErrorJustComplete()
    
    let selectedCell = input.didTapCellSelected
      .map { [weak self] indexPath, albumItem in
        guard let self = self else { return }
        self.updateSelectedCell(itemAt: indexPath, selectedCellAt: albumItem)
    }
    .mapToVoid()
    .asDriverOnErrorJustComplete()
    
    let startCachingImages = input.prefetchItemsTrigger
      .flatMap { self.albumInteractor.startCachingImages(indexPathList: $0) }
      .mapToVoid()
      .asDriverOnErrorJustComplete()
    
    let stopCachingImages = input.cancelPrefetchingTrigger
      .flatMap { self.albumInteractor.stopCachingImages(indexPathList: $0) }
      .mapToVoid()
      .asDriverOnErrorJustComplete()
    
    return Output(
      fetchPhotoItems: fetchPhotoItems,
      loadMore: loadMore,
      updateAlbumItemList: albumItemList.asObservable(),
      startCachingImages: startCachingImages,
      stopCachingImages: stopCachingImages,
      selectedCell: selectedCell
    )
  }
}

// MARK: - Methods

extension AlbumViewModel {
  
  func updateSelectedCell(itemAt indexPath: IndexPath,
                          selectedCellAt albumItem: AlbumItem) {
    
    var newAlbumItemList = albumItemList.value
    
    var item = newAlbumItemList[indexPath.section].items[indexPath.row]
    item.isSelected = !albumItem.isSelected
    
    if item.isSelected {
      self.selectedIndexPathList.append(indexPath)
    } else {
      self.selectedIndexPathList.removeAll(where: { $0 == indexPath })
    }
    
    newAlbumItemList[indexPath.section].items[indexPath.row] = item
    
    self.selectedIndexPathList.enumerated().forEach { offset, indexPath in
      newAlbumItemList[indexPath.section].items[indexPath.row].selectedNumber = offset + 1
    }
    
    albumItemList.accept(newAlbumItemList)
  }
}
