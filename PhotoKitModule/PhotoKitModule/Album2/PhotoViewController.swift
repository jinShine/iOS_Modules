//
//  PhotoViewController.swift
//  PhotoKitModule
//
//  Created by buzz on 2021/05/09.
//  Copyright © 2021 jinnify. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class PhotoViewController2: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

  @IBOutlet var mainCollectionView: UICollectionView!

  let collectionViewCellIdentifier : String = "PhotoCollectionViewCell"

  var currentPhotoFetch: PHFetchResult<PHAsset>!

  override func viewDidLoad() {
    super.viewDidLoad()

    currentPhotoFetch = PHAsset.fetchAssets(with: defaultFetchOptions())
  }

  private func defaultFetchOptions() -> PHFetchOptions {
    let fetchOptions = PHFetchOptions()
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    fetchOptions.sortDescriptors = [sortDescriptor]
    return fetchOptions
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentPhotoFetch.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! PhotoCollectionViewCell

    self.fetchImageAtIndex(index: indexPath, withSize: cell.cellSize) { image, info in
      cell.mainImageView.image = image
    }

    let cellAsset = currentPhotoFetch.object(at: indexPath.row)
    PHImageManager.default().requestImage(for: cellAsset, targetSize: cell.cellSize, contentMode: .aspectFill, options: nil) { image, info in
      cell.mainImageView.image = image
    }

    return cell
  }

  func fetchImageAtIndex(index: IndexPath, withSize size: CGSize, completionHandler: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) {
    let asset = currentPhotoFetch.object(at: index.row)
    PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil, resultHandler: completionHandler)
  }

  func replaceImageAtIndexPath(indexPath: IndexPath, withImage image: UIImage) {
    let asset = self.currentPhotoFetch.object(at: indexPath.row)

    asset.requestContentEditingInput(with: nil) { input, info in
      let output = PHContentEditingOutput(contentEditingInput: input!)
      let outputData = image.pngData()
      let derpString = "derp!"
      let adjustmentData = PHAdjustmentData(formatIdentifier: "Derp", formatVersion: "1.0", data: derpString.data(using: .utf8)!)

      try! outputData?.write(to: output.renderedContentURL)
      output.adjustmentData = adjustmentData

      PHPhotoLibrary.shared().performChanges {
        let assetRequest = PHAssetChangeRequest(for: asset)
        assetRequest.contentEditingOutput = output
      } completionHandler: { completion, error in
        print(completion)
        print(error)
        DispatchQueue.main.async {
          self.currentPhotoFetch = PHAsset.fetchAssets(with: nil)
          self.mainCollectionView.reloadData()
        }
      }

    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    fetchImageAtIndex(index: indexPath, withSize: PHImageManagerMaximumSize) { image, info in
      let sharedSheet = UIActivityViewController(activityItems: [image], applicationActivities: nil)
      sharedSheet.completionWithItemsHandler = { activityType, isCompletion, item, error in
        if isCompletion {
          let extensionItem =  item?.first as! NSExtensionItem
          let itemProvider = extensionItem.attachments?.first as! NSItemProvider
          if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
            itemProvider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil) { image, error in
              self.replaceImageAtIndexPath(indexPath: indexPath, withImage: image as! UIImage)
            }
          }
        }
      }
    }
  }

}
