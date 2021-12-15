//
//  PhotosModel.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import Foundation
import Photos
import UIKit

class PhotosModel: ObservableObject {
    private var allPhotos = PHFetchResult<PHAsset>()
    private var smartAlbums = PHFetchResult<PHAssetCollection>()
    private var userCollections = PHFetchResult<PHAssetCollection>()
    @Published var photos: [PhotoItem] = []
    
    func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized)
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func getAssetImage(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 400, height: 400), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
    
    static func saveMetadata(photoItem: PhotoItem) {
        let changeHandler: () -> Void = {
            let request = PHAssetChangeRequest(for: photoItem.asset)
            request.creationDate = photoItem.creationDate
            request.isFavorite = photoItem.isFavorite
        }
        PHPhotoLibrary.shared().performChanges(changeHandler, completionHandler: nil)
    }
    
    func fetchAssets() {
      let allPhotosOptions = PHFetchOptions()
      allPhotosOptions.sortDescriptors = [
        NSSortDescriptor(
          key: "creationDate",
          ascending: false)
      ]
      
      allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        
        
      for i in 0..<allPhotos.count {
          let currentAsset = allPhotos[i]
          let thumbnail = getAssetThumbnail(asset: currentAsset)
          let image = getAssetImage(asset: currentAsset)
          let photoDate = currentAsset.creationDate ?? Date()
          let isFavorite = currentAsset.isFavorite
          let location = currentAsset.location
          let photoItem = PhotoItem(id: UUID(),
                                    asset: currentAsset,
                                    thumbnail: thumbnail,
                                    image: image,
                                    creationDate: photoDate,
                                    isFavorite: isFavorite,
                                    location: location)
          photos.append(photoItem)
      }
      
      smartAlbums = PHAssetCollection.fetchAssetCollections(
        with: .smartAlbum,
        subtype: .albumRegular,
        options: nil)
      
      userCollections = PHAssetCollection.fetchAssetCollections(
        with: .album,
        subtype: .albumRegular,
        options: nil)
    }
    
    func load() {
        self.getPermissionIfNecessary { granted in
            guard granted else { return }
            self.fetchAssets()
        }
    }
}
