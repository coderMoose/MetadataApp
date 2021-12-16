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
    
    var selectedPhotos: [PhotoItem] {
        photos.filter { $0.isSelected }
    }
    
    func resetAllToUnselected() {
        for selectedPhoto in selectedPhotos {
            selectedPhoto.isSelected = false
        }
    }
    
    func load() {
        self.getPermissionIfNecessary { granted in
            guard granted else { return }
            self.fetchAssets()
        }
    }
    
    static func saveMetadata(photoItems: [PhotoItem]) {

        let changeHandler: () -> Void = {
            for photoItem in photoItems {
                let request = PHAssetChangeRequest(for: photoItem.asset)
                request.creationDate = photoItem.creationDate
                request.isFavorite = photoItem.isFavorite
            }
        }

        PHPhotoLibrary.shared().performChanges(changeHandler, completionHandler: nil)
    }

    private func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized)
        }
    }
    
    private func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    private func getAssetImage(asset: PHAsset) -> UIImage {
//        let screenSize: CGRect = UIScreen.main.bounds
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 400, height: 400), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
        
    private func fetchAssets() {
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
    
}
