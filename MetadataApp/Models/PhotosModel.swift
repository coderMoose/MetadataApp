//
//  PhotosModel.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import Foundation
import Photos
import UIKit
import SwiftUI

// This class stores all the methods necessary to interact with the user's photo library (e.g. loading photos, saving photos...)
class PhotosModel: NSObject, ObservableObject {
    private var allPhotos = PHFetchResult<PHAsset>()
    private var smartAlbums = PHFetchResult<PHAssetCollection>()
    private var userCollections = PHFetchResult<PHAssetCollection>()
    @Published var photos: [PhotoItem] = []
    
    // Computed array that stores the selected photos
    var selectedPhotos: [PhotoItem] {
        photos.filter { $0.isSelected }
    }
    
    // Resets the selected photos
    func resetAllToUnselected() {
        for selectedPhoto in selectedPhotos {
            selectedPhoto.isSelected = false
        }
    }
    
    // Loads all of the user's photos
    func load(insertNewPhotosAtBeginning: Bool = false) {
        self.getPermissionIfNecessary { granted in
            guard granted else { return }
            self.fetchAssets(insertNewPhotosAtBeginning: insertNewPhotosAtBeginning)
        }
    }
    
    // Saves the metadata of a selected photo
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
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 400, height: 400), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
    
    // Get all of the photos from the user's photo library
    private func fetchAllPhotos() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
      
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
    }
    
    // Get all of the assets from the user's photo library
    private func fetchAssets(insertNewPhotosAtBeginning: Bool = false) {
        
        fetchAllPhotos()
        
        for i in 0..<allPhotos.count {
            let currentAsset = allPhotos[i]
            let photoIsAlreadyInAlbum = photos.contains(where: { item in
                item.asset.localIdentifier == currentAsset.localIdentifier
            })
            if photoIsAlreadyInAlbum {
                continue
            } else {
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
                if insertNewPhotosAtBeginning {
                    photos.insert(photoItem, at: 0)
                } else {
                    photos.append(photoItem)
                }
            }
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
    
    func addImageToPhotoLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc
    private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        withAnimation {
            self.load(insertNewPhotosAtBeginning: true)
        }
    }
}
