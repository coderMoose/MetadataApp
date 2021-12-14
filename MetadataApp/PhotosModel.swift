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
    @Published var photos: [UIImage] = []
    
    func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized)
        }
    }
    
    func fetchAssets() {
      let allPhotosOptions = PHFetchOptions()
      allPhotosOptions.sortDescriptors = [
        NSSortDescriptor(
          key: "creationDate",
          ascending: false)
      ]
      
      allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
      
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
