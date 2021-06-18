//
//  PhotoPickerManager.swift
//  Common
//
//  Created by buzz on 2021/06/03.
//  Copyright © 2021 LIFIC Inc. All rights reserved.
//

import Photos
import RxSwift
import RxCocoa

public typealias Asset = PHAsset
public typealias AssetCollection = PHAssetCollection
public typealias FetchResult = PHFetchResult

public protocol PhotoPickerable {
  var fetchImage: PublishSubject<UIImage?> { get }

  func grantAlbumPermission() -> Observable<Bool>
  func grantCameraPermission() -> Observable<Bool>
  func showCamera() -> Single<UIImagePickerController>
  func showPhotoLibrary() -> Single<UIImagePickerController>
  func fetchOptions() -> PHFetchOptions
  func fetchAllAssets() -> PHFetchResult<PHAsset>
  func fetchUserLibraryAlbums() -> PHFetchResult<PHAssetCollection>
  func fetchFavoriteAlbums() -> PHFetchResult<PHAssetCollection>
  func fetchMyAlbums() -> PHFetchResult<PHAssetCollection>
}

public class PhotoPickerManager: NSObject, PhotoPickerable {

  // MARK: - Properties

  private var imagePicker: UIImagePickerController

  public let fetchImage = PublishSubject<UIImage?>()

  // MARK: - Initialize

  public override init() {
    imagePicker = UIImagePickerController()
    super.init()
    imagePicker.delegate = self
  }

  // MARK: - Methods

  public func grantAlbumPermission() -> Observable<Bool> {
    return Observable<Bool>.create { observer in
      guard PHPhotoLibrary.authorizationStatus() != .authorized else {
        observer.onNext(true)
        observer.onCompleted()
        return Disposables.create()
      }

      PHPhotoLibrary.requestAuthorization { status in
        observer.onNext(status == .authorized ? true : false)
        observer.onCompleted()
      }

      return Disposables.create()
    }
  }

  public func grantCameraPermission() -> Observable<Bool> {
    return Observable<Bool>.create { observer in
      guard AVCaptureDevice.authorizationStatus(for: .video) != .authorized else {
        observer.onNext(true)
        observer.onCompleted()
        return Disposables.create()
      }

      AVCaptureDevice.requestAccess(for: .video) { isGranted in
        observer.onNext(isGranted)
        observer.onCompleted()
      }

      return Disposables.create()
    }
  }

  public func showCamera() -> Single<UIImagePickerController> {
    return Single.create { single in
      let type = UIImagePickerController.SourceType.camera

      guard UIImagePickerController.isSourceTypeAvailable(type) else {
        return Disposables.create()
      }

      self.imagePicker.sourceType = type
      self.imagePicker.allowsEditing = true
      single(.success(self.imagePicker))

      return Disposables.create()
    }
  }

  public func showPhotoLibrary() -> Single<UIImagePickerController> {
    return Single.create { single in
      let type = UIImagePickerController.SourceType.photoLibrary

      guard UIImagePickerController.isSourceTypeAvailable(type) else {
        return Disposables.create()
      }

      self.imagePicker.sourceType = type
      single(.success(self.imagePicker))

      return Disposables.create()
    }
  }

  public func fetchOptions() -> PHFetchOptions {
    let options = PHFetchOptions()
    options.sortDescriptors = [
      NSSortDescriptor(key: "creationDate", ascending: false)
    ]

    return options
  }

  /// 최근 항목 Asset
  public func fetchAllAssets() -> PHFetchResult<PHAsset> {
    let userLibraryCollection = PHAssetCollection.fetchAssetCollections(
      with: .smartAlbum,
      subtype: .smartAlbumUserLibrary,
      options: nil
    )

    guard let collection = userLibraryCollection.firstObject else {
      return PHFetchResult<PHAsset>()
    }

    let allPhotos = PHAsset.fetchAssets(in: collection, options: fetchOptions())

    return allPhotos
  }

  /// 최근 항목 Album
  public func fetchUserLibraryAlbums() -> PHFetchResult<PHAssetCollection> {
    let recentAlbums = PHAssetCollection.fetchAssetCollections(
      with: .smartAlbum,
      subtype: .smartAlbumUserLibrary,
      options: nil
    )

    return recentAlbums
  }

  /// 즐겨찾는 항목 Album
  public func fetchFavoriteAlbums() -> PHFetchResult<PHAssetCollection> {
    let favoriteAlbums = PHAssetCollection.fetchAssetCollections(
      with: .smartAlbum,
      subtype: .smartAlbumFavorites,
      options: nil
    )

    return favoriteAlbums
  }

  /// 내 앨범 Album
  public func fetchMyAlbums() -> PHFetchResult<PHAssetCollection> {
    let albumRegular = PHAssetCollection.fetchAssetCollections(
      with: .album,
      subtype: .albumRegular,
      options: nil
    )

    return albumRegular
  }

  // MARK: Static

  public static func fetchOptions() -> PHFetchOptions {
    let options = PHFetchOptions()
    options.sortDescriptors = [
      NSSortDescriptor(key: "creationDate", ascending: false)
    ]

    return options
  }
}

// MARK: - ImagePicker delegate

extension PhotoPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
    let selectedImage = editedImage ?? originalImage

    fetchImage.onNext(selectedImage)

    picker.dismiss(animated: true, completion: nil)
  }

  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}
